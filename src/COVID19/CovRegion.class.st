"
I contain the data for a particular region.

I may contain subdivisions, and different datasets.
"
Class {
	#name : #CovRegion,
	#superclass : #Object,
	#instVars : [
		'name',
		'subdivisions',
		'confirmed',
		'deaths',
		'recovered',
		'population',
		'countDiv',
		'sortBy',
		'div',
		'selection',
		'canvas',
		'graphWidth',
		'inUS',
		'popScale',
		'ratio',
		'graphHeight',
		'app',
		'ctx'
	],
	#classVars : [
		'BarWidth'
	],
	#pools : [
		'PjBrowserGlobals'
	],
	#category : #'COVID19-Kernel'
}

{ #category : #'class initialization' }
CovRegion class >> initialize [
	BarWidth := 7.

]

{ #category : #sorting }
CovRegion >> <= other [
	sortBy isNumber ifTrue: [ ^ other sortBy <= sortBy ].
	^ sortBy <= other sortBy
]

{ #category : #displaying }
CovRegion >> addTo: aDiv [
	| rect |
	rect := aDiv getBoundingClientRect.
	ratio := 1.0 * rect height / rect width.
	aDiv append: self div.

]

{ #category : #accessing }
CovRegion >> app: anApp [
	app := anApp.

]

{ #category : #accessing }
CovRegion >> canvas [
	| save |
	canvas ifNotNil: [ ^ canvas ].
	canvas := document createElement: #canvas.
	ctx := self canvas getContext: '2d'.
	ctx translate: 0.5 y: 0.5.
	save := selection.
	selection := 14.
	graphWidth ifNil: [ graphWidth := (self selectedDatasets collect: #days) max * BarWidth + 5].
	graphHeight := 0.9 * ratio * graphWidth.
	selection := save.
	canvas width: graphWidth.
	canvas height: graphHeight.
	^ canvas
]

{ #category : #accessing }
CovRegion >> confirmed [
	^ confirmed ifNil: [
			confirmed := CovDataset new color: 'orange'.
			subdivisions ifNotNil: [
				subdivisions valuesDo: [: sub | confirmed add: sub confirmed]
			].
			confirmed
		]
]

{ #category : #sorting }
CovRegion >> confirmedPerCapSort [
	confirmed ifNil: [ subdivisions ifNil: [ ^ nil ]].
	popScale ifNil: [ ^ nil ].
	sortBy := (1000000*popScale * self confirmed count) asInteger.
	sortBy isZero ifTrue: [ ^ nil ].
	self setCount: sortBy.

]

{ #category : #sorting }
CovRegion >> confirmedSort [
	confirmed ifNil: [ subdivisions ifNil: [ ^ nil ]].
	sortBy := self confirmed count.
	sortBy isZero ifTrue: [ ^ nil ].
	self setCount: sortBy.

]

{ #category : #accessing }
CovRegion >> countDiv: aDiv [
	countDiv := aDiv.

]

{ #category : #accessing }
CovRegion >> deaths [
	^ deaths ifNil: [
			deaths := CovDataset new color: 'red'.
			subdivisions ifNotNil: [
				subdivisions valuesDo: [: sub | deaths add: sub deaths]
			].
			deaths
		]
]

{ #category : #sorting }
CovRegion >> deathsPerCapSort [
	deaths ifNil: [ subdivisions ifNil: [ ^ nil ]].
	popScale ifNil: [ ^ nil ].
	sortBy := (1000000*popScale * self deaths count) asInteger.
	sortBy isZero ifTrue: [ ^ nil ].
	self setCount: sortBy.

]

{ #category : #sorting }
CovRegion >> deathsSort [
	deaths ifNil: [ subdivisions ifNil: [ ^ nil ]].
	sortBy := self deaths count.
	sortBy isZero ifTrue: [ ^ nil ].
	self setCount: sortBy.

]

{ #category : #displaying }
CovRegion >> div [
	| temp |
	div ifNotNil: [ ^ div ].
	div := document createElement: #div.
	temp := document createElement: #div.
	temp innerText: name.
	temp className: #name.
	div className: #graph.
	div append: temp.
	div append: self canvas.
	temp := document createElement: #div.
	temp innerHTML: 'Total cases <span class="confirmed">',confirmed count asString,' confirmed</span>, <span class="deaths">',deaths count asString,' deaths</span>, <span class="recovered">',recovered count asString,' recovered</span>.'.
	temp className: #stats.
	div append: temp.
	div addEventListener: #click block: [: ev | ev stopPropagation. app toggleGraph: self ].
	^ div
]

{ #category : #accessing }
CovRegion >> first [
	^  (self selectedDatasets collect: #first) min
]

{ #category : #formatting }
CovRegion >> graph: largest step: step per: perCapita start: startDate from: first to: last [
	| datasets date monthPos scale x barWidth height perCapitaString |
	perCapita ifNil: [perCapitaString := ''.] ifNotNil: [ perCapitaString := ' per ',(perCapita = 1 ifTrue: [ 'capita' ] ifFalse: [ perCapita toLocaleString ])].
	datasets := self selectedDatasets.
	datasets do: [: dataset |
		(selection bitAnd: 1) = 0 ifTrue: [ dataset raw ] ifFalse: [ dataset smooth ].
	].
	date := startDate.
	self canvas.
	barWidth := graphWidth / (last-first+1).
	height := 0.95*graphHeight.
	ctx clearRect: 0 y: 0 width: graphWidth height: graphHeight.
	ctx textAlign: 'center'.
	scale := (selection bitAnd: 16) ~= 0 ifTrue: [
		popScale ifNil: [
				ctx fillStyle: #grey.
				ctx font: 'italic small-caps bold 24px arial'.
				ctx fillText: 'No population data' x: 0.5*graphWidth y: 0.5*graphHeight.
				^ self
			] ifNotNil: [
				height/largest/(population/perCapita)
		]] ifFalse: [
			height/largest
		].
	ctx fillStyle: '#888'.
	ctx fillRect: 0 y: graphHeight-1 width: graphWidth height: 1.
	0 to: largest by: step do: [: y |
		ctx fillRect: 0 y: height-(y*height/largest) width: graphWidth height: 1.
		y>0 ifTrue: [
			ctx fillText: y asString,perCapitaString x: 0.5 * graphWidth y: height*1.01-(y*height/largest)
	]].
	x := 0.
	first to: last do: [: index |
		date dayOfWeek = 1 ifTrue: [ ctx fillStyle: '#eee'. ctx fillRect: x-1 y: 0 width: 1 height: height. ].
		date dayOfMonth = 1 ifTrue: [ ctx fillStyle: '#888'. ctx fillRect: x-1 y: 0 width: 1 height: graphHeight. ].
		date dayOfMonth = 15 ifTrue: [ monthPos := x ].
		(date dayOfMonth = 20 and: [ monthPos notNil]) ifTrue: [
			ctx fillStyle: #black.
			ctx font: 'small-caps 12px arial'.
			ctx fillText: date monthName x: monthPos y: graphHeight - 5
		].
		date := date addDays: 1.
		(selection bitAnd: 32) = 0 ifTrue: [
			datasets do: [: dataset | dataset day: index]
		] ifFalse: [
			datasets do: [: dataset | dataset daySum: index]
		].
		datasets asSortedCollection do: [: dataset | | barHeight |
			barHeight := dataset dayValue*scale.
			ctx fillStyle: dataset color.
			ctx fillRect: x y: height - barHeight width: barWidth-1 height: barHeight.
		].
		x := x + barWidth.
	].
	^ ctx
]

{ #category : #accessing }
CovRegion >> hasConfirmed [
	^ confirmed isNotNil
]

{ #category : #accessing }
CovRegion >> inUS: aBoolean delta: delta population: anInteger [
	inUS := aBoolean.
	population := (delta  and: [ population notNil ] )ifTrue: [ population + anInteger ] ifFalse: [ anInteger ].

]

{ #category : #initialization }
CovRegion >> initialize [
	super initialize.
	selection := 14.

]

{ #category : #accessing }
CovRegion >> last [
	^  (self selectedDatasets collect: #last) max
]

{ #category : #accessing }
CovRegion >> max [
	| max |
	max := (self selectedDatasets collect: ((selection bitAnd: 32) = 0 ifTrue: [#max] ifFalse: [#sum])) max.
	^ (selection bitAnd: 16) ~= 0 ifTrue: [
			popScale ifNil: [ ^ 0 ] ifNotNil: [ ^ popScale * max ]
		] ifFalse: [ ^ max ]

]

{ #category : #displaying }
CovRegion >> n: n index: index of: size [
	| nrows row col ncols x y scale n2 |
	scale := 1/n.
	n2 := n * n.
	nrows := (size*scale) ceiling.
	row := (index-1) // n + 1.
	col := (index-1) \\ n + 1.
	ncols := row = nrows ifTrue: [ (size-1)\\n+1 ] ifFalse: [ n ].
	x := (self percent: col of: ncols)*n/2.
	y := (self percent: row of: nrows)*n/2-(index*n2)+n2.
	self div style transform: 'scale(',scale asString,') translate(',(100*x*scale) asString,'%,',(100*y*scale),'%)'.
	
]

{ #category : #accessing }
CovRegion >> name [
	^ name
]

{ #category : #accessing }
CovRegion >> name: aString [ 
	name := aString.
]

{ #category : #sorting }
CovRegion >> nameSort [
	sortBy := name.
	self setCount: population.

]

{ #category : #parsing }
CovRegion >> parse: aCollection as: aSymbol [
	(self perform: aSymbol) parse: aCollection.

]

{ #category : #displaying }
CovRegion >> percent: i of: n [
	^ -1-n+(2*i)
	
]

{ #category : #accessing }
CovRegion >> population: pop [
		(pop = 0 or: [pop isNil]) ifTrue: [ population := popScale := nil ] ifFalse: [ population := pop. popScale := 1.0/pop ].

]

{ #category : #sorting }
CovRegion >> populationSort [
	population ifNil: [ ^ nil ].
	sortBy := population.
	self setCount: sortBy.

]

{ #category : #smoothing }
CovRegion >> raw [
	self confirmed raw.
	self deaths raw.
	self recovered raw.

]

{ #category : #accessing }
CovRegion >> recovered [
	^ recovered ifNil: [
			recovered := CovDataset new color: 'green'.
			subdivisions ifNotNil: [
				subdivisions valuesDo: [: sub | recovered add: sub recovered]
			].
			recovered
		]
]

{ #category : #sorting }
CovRegion >> recoveredPerCapSort [
	recovered ifNil: [ subdivisions ifNil: [ ^ nil ]].
	popScale ifNil: [ ^ nil ].
	sortBy := (1000000*popScale * self recovered count) asInteger.
	sortBy isZero ifTrue: [ ^ nil ].
	self setCount: sortBy.

]

{ #category : #sorting }
CovRegion >> recoveredSort [
	recovered ifNil: [ subdivisions ifNil: [ ^ nil ]].
	sortBy := self recovered count.
	sortBy isZero ifTrue: [ ^ nil ].
	self setCount: sortBy.

]

{ #category : #displaying }
CovRegion >> remove [
	self div remove.

]

{ #category : #accessing }
CovRegion >> selectedDatasets [
	| mask |
	mask := 1.
	^ {self confirmed. self deaths. self recovered} select: [: dataset |
			mask := 2 * mask.
			(dataset notNil and: [0 ~= (selection bitAnd: mask)]) and: [ (selection bitAnd: 1) = 0 ifTrue: [ dataset raw ] ifFalse: [ dataset smooth ]. true ]
		]
]

{ #category : #accessing }
CovRegion >> selection: anInteger [
	selection := anInteger.

]

{ #category : #sorting }
CovRegion >> setCount: value [
	countDiv ifNotNil: [ countDiv innerText: (value ifNil: ['']) ].

]

{ #category : #accessing }
CovRegion >> setPopulation: populations [
	| lookup |
	lookup := name.
	(inUS and: [name = 'Georgia']) ifTrue: [ lookup := 'Georgia,USA' ].
	populations at: lookup ifPresent: [ : assoc |
		self population: assoc value.
	] ifAbsent: [].
	self subdivisions do: [: sub | sub setPopulation: populations ].

]

{ #category : #smoothing }
CovRegion >> smooth [
	self confirmed smooth: 4.
	self deaths smooth: 4.
	self recovered smooth: 4.

]

{ #category : #smoothing }
CovRegion >> smooth4 [
	self confirmed smooth: 4.
	self deaths smooth: 4.
	self recovered smooth: 4.

]

{ #category : #sorting }
CovRegion >> sortBy [
	^ sortBy
]

{ #category : #accessing }
CovRegion >> subdivision: aString [ 
	| countryName |
	aString isEmpty ifTrue: [ ^ self ].
	countryName := aString = #US ifTrue: [ 'United States' ] ifFalse: [ aString ].
	^ self subdivisions at: countryName ifAbsentPut: [ self class new name: countryName ]
]

{ #category : #accessing }
CovRegion >> subdivisions [
	^ subdivisions ifNil: [ subdivisions := Dictionary new ]
]

{ #category : #accessing }
CovRegion >> subdivisionsSortedBy: order [
	| sort |
	sort := (order,#Sort) asSymbol.
	self perform: sort.
	^ ((self subdivisions collect: sort) reject: #isNil) asSortedCollection
]
