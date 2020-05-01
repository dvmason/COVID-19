"
Load data from
   https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv
 and
   https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv
 and display it in a browser window.
"
Class {
	#name : #CovidApp,
	#superclass : #PjFileBasedWebApp,
	#instVars : [
		'scaling',
		'graphs',
		'world',
		'pendingReads',
		'graphsDiv',
		'listDiv',
		'populations',
		'startDate',
		'endDate',
		'sortBy',
		'faqDiv'
	],
	#pools : [
		'CovGlobals'
	],
	#category : #COVID19
}

{ #category : #description }
CovidApp class >> appClasses [
	<pharoJsSkip>
	^super appClasses, { CovElement}
]

{ #category : #accessing }
CovidApp >> countries [
	^ world subdivisions
]

{ #category : #parsing }
CovidApp >> dequote: fields [
	^ fields species streamContents: [: s | | quoted |
			quoted := nil.
			fields do: [: each |
				quoted ifNil: [
					(each beginsWith: '"') ifTrue: [
						(each endsWith: '"') ifTrue: [
							s nextPut: each allButFirst allButLast
						] ifFalse: [
							quoted := each allButFirst
					]] ifFalse: [
						s nextPut: each
				]] ifNotNil: [
					(each endsWith: '"') ifTrue: [
						s nextPut: quoted,',',each allButLast. quoted := nil
					] ifFalse: [
						quoted := quoted,',',each
					]
			]].
			quoted ifNotNil: [ s nextPut: quoted ].
	]
]

{ #category : #displaying }
CovidApp >> fileReadingDone [
	self setPopulations.
	self populateList: sortBy value.

]

{ #category : #initialization }
CovidApp >> initialize [
	super initialize.
	world := CovRegion new name: 'World'.
	pendingReads := 0.
	populations := Dictionary new.
	graphs := OrderedCollection new.

]

{ #category : #parsing }
CovidApp >> parse: aString as: type isUS: isUS [
	self parseCSV: aString with: [: fields |
		| country target |
		country := world subdivision: (fields at: (isUS ifTrue: [8] ifFalse: [2])).
		target := country subdivision: (fields at: (isUS ifTrue: [7] ifFalse: [1])).
		target parse: (fields allButFirst: (isUS ifTrue: [11] ifFalse: [4])) as: type.
	] header: [: fields |
		startDate := (fields at: (isUS ifTrue: [12] ifFalse: [5])) asDate.
		endDate := fields last asDate.
	].

]

{ #category : #parsing }
CovidApp >> parseCSV: aString with: aBlock [
	^ self parseCSV: aString with: aBlock header: []
]

{ #category : #parsing }
CovidApp >> parseCSV: aString with: aBlock header: headerBlock [
	| header |
	header := true.
	(Character lf split: aString)
		do: [ :bString | 
			(Character cr split: bString)
				do: [ :row | | fields |
					fields := $, split: row.
					(row includes: $") ifTrue: [
						fields := self dequote: fields].
					header ifTrue: [
						header := false.
						headerBlock cull: fields
					] ifFalse: [
						row isEmpty ifFalse: [
							aBlock value: fields
		]]]]
]

{ #category : #parsing }
CovidApp >> parsePopulations: aString [
	self parseCSV: aString with: [: fields | | year population |
		year := fields third.
		population := (fields at: 4) asNumber.
		populations at: fields first ifPresent: [: assoc |
				assoc key < year ifTrue: [ assoc key: year value: population ]
			] ifAbsentPut: [ year -> population ]]

]

{ #category : #displaying }
CovidApp >> populate: region depth: d in: aNode sortBy: order [
	| subs div count |
	count := document createElement: #div.
	count classList: 'kind population'.
	region countDiv: count.
	subs := region subdivisionsSortedBy: order.
	div := document createElement: #div.
	div className: #list,d asString.
	d > 1 & subs notEmpty ifTrue: [
		| toggle |
		toggle := document createElement: #div.
		toggle className: #toggle.
		div append: toggle.
		toggle addEventListener: #click block: [: ev | ev stopPropagation. div classList toggle: #open ].
	].
	div append: (document createTextNode: region name).
	div append: count.
	div addEventListener: #click block: [: ev | ev stopPropagation. self toggleGraph: region ].
	aNode append: div.
	subs do: [: sub |
		self populate: sub depth: d+1 in: (d>1 ifTrue: [div] ifFalse: [aNode]) sortBy: order.
	].

]

{ #category : #displaying }
CovidApp >> populateList: order [
	| clone |
	clone := listDiv cloneNode.
	listDiv parentNode replaceChild: clone for: listDiv.
	listDiv := clone.
	self populate: world depth: 1 in: listDiv sortBy: order.

]

{ #category : #parsing }
CovidApp >> read: aUrl then: aBlock [
	pendingReads := pendingReads + 1.
	(window fetch: aUrl) then: [ :response |
		response ok ifTrue: [
			self readWith: response body getReader then: [: result |
				aBlock value: result.
				pendingReads := pendingReads - 1.
				pendingReads = 0 ifTrue: [ self fileReadingDone].
		]] ifFalse: [
			pendingReads := pendingReads - 1.
			pendingReads = 0 ifTrue: [ self fileReadingDone].
	]].
]

{ #category : #parsing }
CovidApp >> readWith: reader then: aBlock [
	| result processText decoder |
	result := ''.
	decoder := TextDecoder new.
	processText := [: response | | value |
		response done ifTrue: [
				console log: 'Done: ',result size with: Date js_now.
				aBlock value: result
			] ifFalse: [
				value := decoder decode: response value.
				result := result,value.
				reader read then: processText.
			]
		].
	reader read then: processText.


]

{ #category : #displaying }
CovidApp >> resizeGraphs [
	| size nrows |
	size := graphs size sqrt ceiling.
	nrows := (graphs size / size) ceiling.
	graphs withIndexDo: [: graph : index | | row col ncols |
		row := (index - 1 / size) floor.
		col := index - (row * size).
		ncols := graphs size-index min: size.
		graph scale: 1.0/size row: row+1 of: nrows col: col of: ncols.
	].

]

{ #category : #'start-stop' }
CovidApp >> scale: factor [
	scaling := factor * scaling.
	graphs do: [ : each |
		each style transform: 'scale(',scaling asString,')'.
	].

]

{ #category : #displaying }
CovidApp >> setPopulations [
	world setPopulation: populations.


]

{ #category : #accessing }
CovidApp >> sorted [
	^ world subdivisionsSortedBy: #name
]

{ #category : #'start-stop' }
CovidApp >> start [
	super start.
	#(confirmed deaths recovered) do: [: type |
		#(global US) do: [: region |
			self read: 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_',type,'_',region,'.csv'
					then: [ : result | self parse: result as: type isUS: region=#US ]]].
	self read: 'https://raw.githubusercontent.com/datasets/population/master/data/population.csv' then: [: result | self parsePopulations: result].
	scaling := 1.
	document body
		addEventListener: #keyup
		block: [ :ev | 
			ev keyCode = 187
				ifTrue: [ self scale: 1.25 ].	"+"
			ev keyCode = 189
				ifTrue: [ self scale: 0.8 ]	"-" ].
	listDiv := document getElementById: #list.
	graphsDiv := document getElementById: #graphs.
	sortBy := document getElementById: #sortby.
	sortBy addEventListener: #change block: [ : ex |
		self populateList: sortBy value
	].
	faqDiv := document getElementById: #FAQ.

]

{ #category : #displaying }
CovidApp >> toggleGraph: region [
	(graphs includes: region) ifTrue: [
		graphs remove: region.
		region remove.
		graphs ifEmpty: [ graphsDiv append: faqDiv ].
	] ifFalse: [
		graphs ifEmpty: [
			graphsDiv removeChild: faqDiv.
		].
		graphs add: region.
		region addTo: graphsDiv.
	].
	graphs ifNotEmpty: [ self resizeGraphs ].

]
