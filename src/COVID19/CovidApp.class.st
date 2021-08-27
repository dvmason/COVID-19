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
		'sortBy',
		'faqDiv',
		'selections',
		'topGraphs',
		'hideDiv'
	],
	#classVars : [
		'NormalizedNames'
	],
	#pools : [
		'CovGlobals'
	],
	#category : #'COVID19-Kernel'
}

{ #category : #description }
CovidApp class >> appClasses [
	<pharoJsSkip>
	^super appClasses, { CovElement}
]

{ #category : #'class initialization' }
CovidApp class >> initialize [
	NormalizedNames := Dictionary new.
	NormalizedNames at: 'Hong Kong SAR, China' put: 'Hong Kong'.
	NormalizedNames at: 'Macao SAR, China' put: 'Macao'.
	NormalizedNames at: 'Syrian Arab Republic' put: 'Syria'.
	NormalizedNames at: 'Myanmar' put: 'Burma'.
	NormalizedNames at: 'Congo, Dem. Rep.' put: 'Congo (Kinshasa)'.
	NormalizedNames at: 'Congo, Rep.' put: 'Congo (Brazzaville)'.
	NormalizedNames at: 'Lao PDR' put: 'Laos'.
	NormalizedNames at: 'Iran, Islamic Rep.' put: 'Iran'.
	NormalizedNames at: 'Korea, Dem. People’s Rep.' put: 'Korea, North'.
	NormalizedNames at: 'Korea, Rep.' put: 'Korea, South'.
	NormalizedNames at: 'Russian Federation' put: 'Russia'.
	NormalizedNames at: 'Bahamas, The' put: 'Bahamas'.
	NormalizedNames at: 'Egypt, Arab Rep.' put: 'Egypt'.
	NormalizedNames at: 'Gambia, The' put: 'Gambia'.
	NormalizedNames at: 'Micronesia, Fed. Sts.' put: 'Micronesia'.
	NormalizedNames at: 'Venezuela, RB' put: 'Venezuela'.
	NormalizedNames at: 'American Samoa' put: 'Samoa'.
	NormalizedNames at: 'Brunei Darussalam' put: 'Brunei'.
	NormalizedNames at: 'Czech Republic' put: 'Czechia'.
	NormalizedNames at: 'Kyrgyz Republic' put: 'Kyrgyzstan'.
	NormalizedNames at: 'Slovak Republic' put: 'Slovakia'.
	NormalizedNames at: 'St. Kitts and Nevis' put: 'Saint Kitts and Nevis'.
	NormalizedNames at: 'St. Lucia' put: 'Saint Lucia'.
	NormalizedNames at: 'St. Vincent and the Grenadines' put: 'Saint Vincent and the Grenadines'.

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
	populations at: 'Ontario' put: 2019->14570000.
	populations at: 'Quebec' put: 2019->8485000.
	populations at: 'British Columbia' put: 2019->5071000.
	populations at: 'Alberta' put: 2019->4371000.
	populations at: 'Manitoba' put: 2019->1369000.
	populations at: 'Saskatchewan' put: 2019->1174000.
	populations at: 'Nova Scotia' put: 2019->971395.
	populations at: 'New Brunswick' put: 2019->776827.
	populations at: 'Newfoundland and Labrador' put: 2019->521542.
	populations at: 'Prince Edward Island' put: 2019->156947.
	populations at: 'Northwest Territories' put: 2019->44826.
	populations at: 'Nunavut' put: 2019->38780.
	populations at: 'Yukon' put: 2019->35874.
	populations at: 'California' put: 2020->39747267.
	populations at: 'Texas' put: 2020->29087070.
	populations at: 'Florida' put: 2020->21646155.
	populations at: 'New York' put: 2020->19491339.
	populations at: 'Pennsylvania' put: 2020->12813969.
	populations at: 'Illinois' put: 2020->12700381.
	populations at: 'Ohio' put: 2020-> 11718568.
	populations at: 'Georgia,USA' put: 2020-> 10627767.
	populations at: 'North Carolina' put: 2020->10497741.
	populations at: 'Michigan' put: 2020->10020472.
	populations at: 'New Jersey' put: 2019->8820000.
	populations at: 'Massachusetts' put: 2019->6893000.
	populations at: 'Connecticut' put: 2019->3565000.
	graphs := OrderedCollection new.
	topGraphs := OrderedCollection new.

]

{ #category : #parsing }
CovidApp >> parse: aString as: type isUS: isUS [
	| hasPopulation |
	hasPopulation := false.
	self parseCSV: aString with: [: fields |
		| country target |
		fields second = 'Recovered' ifFalse: [
			country := world subdivision: (fields at: (isUS ifTrue: [8] ifFalse: [2])).
			target := country subdivision: (fields at: (isUS ifTrue: [7] ifFalse: [1])).
			target parse: (fields allButFirst: (isUS ifTrue: [12] ifFalse: [4])) as: type.
			target inUS: isUS delta: ((fields at: 6) notEmpty) population: (hasPopulation ifTrue: [ (fields at: 13) parseInt ] ifFalse: [ 0 ] ).
	]] header: [: fields |
		hasPopulation := (fields at: 13)='Population'.
		startDate ifNil: [startDate := (fields at: (isUS ifTrue: [hasPopulation ifTrue: [14] ifFalse: [13]] ifFalse: [5])) asDate].
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
	| name |
	self parseCSV: aString with: [: fields | | year population |
		year := fields third asNumber.
		population := (fields at: 4) asNumber.
		name := fields first.
		NormalizedNames at: name ifPresent: [: value | name := value ].
		populations at: name ifPresent: [: assoc |
				assoc key < year ifTrue: [ assoc key: year value: population ]
			] ifAbsentPut: [ year -> population ]
	].
	populations at: 'Taiwan*' put: 23780000.

]

{ #category : #displaying }
CovidApp >> populate: region depth: d in: aNode sortBy: order [
	| subs div count |
	count := document createElement: #div.
	count classList: 'kind population'.
	region countDiv: count.
	region app: self.
	subs := region subdivisionsSortedBy: order.
	div := document createElement: #div.
	div className: #list,d asString.
	d > 10 & subs notEmpty ifTrue: [
		| toggle |
		toggle := document createElement: #div.
		toggle className: #toggle.
		div append: toggle.
		toggle addEventListener: #click block: [: ev | ev stopPropagation. div classList toggle: #open ].
	].
	d = 2 ifTrue: [ topGraphs add: region ].
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
	topGraphs := OrderedCollection new.
	self populate: world depth: 1 in: listDiv sortBy: order.

]

{ #category : #parsing }
CovidApp >> read: aUrl then: aBlock [
	pendingReads := pendingReads + 1.
	(global fetch: aUrl) then: [ :response |
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
	| max first last step perCapita |
	max := graphs inject: 0 into: [: maxSoFar : each | maxSoFar max: (each selection: selections;max) ].
	max = 0 ifTrue: [ ^ self ].
	step := 1.
	(selections bitAnd: 16) = 0 ifTrue: [
		[ step*10 < max ] whileTrue: [ step := step * 10 ].
		[ max/step < 3 ] whileTrue: [ step := step / 2 ].
		perCapita := nil
	] ifFalse: [
		perCapita := 1.
		[ max < 3 ] whileTrue: [ perCapita := perCapita * 10. max := max * 10 ].
		[ max/step > 6 ] whileTrue: [ step := step * 5 ].
  ].
	first := graphs inject: 1000000 into: [: minSoFar : each | minSoFar min: each first ].
	last := graphs inject: 0 into: [: maxSoFar : each | maxSoFar max: each last ].
	graphs withIndexDo: [: graph : index |
		graph graph: max step: step per: perCapita start: (startDate addDays: -1 + first) from: first to: last.
		graph n: graphs size sqrt ceiling index: index of: graphs size.
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

{ #category : #'start-stop' }
CovidApp >> setupElements [
	faqDiv := document getElementById: #FAQ.
	listDiv := document getElementById: #list.
	graphsDiv := document getElementById: #graphs.
	hideDiv := document createElement: #div.
	hideDiv id: #hide.
	hideDiv innerText: 'Click on any graph to remove it.'.
	sortBy := document getElementById: #sortby.
	sortBy addEventListener: #change block: [ : ex |
		self populateList: sortBy value.
		self resizeGraphs.
	].
	#(9 16 25 36 49 64) do: [: n |
		(document getElementById: #top,n asString) ifNotNil: [: element |
			element addEventListener: #click block: [
				(topGraphs first: n) do: [: each | self toggleGraph: each ].
	]]].
	(document getElementById: #smoothing) ifNotNil: [: smoothing |
		smoothing addEventListener: #change block: [ : ex |
			graphs do: smoothing value.
			self resizeGraphs.
	]].
	selections := 0.
	#(raw confirmed deaths recovered perCapita cumulative) withIndexDo: [: each : index | | element bit |
		element := document getElementById: each.
		element ifNotNil: [
			bit := 2 raisedTo: index-1.
			element checked ifTrue: [ selections := selections | bit ].
			element addEventListener: #change block: [: ex |
				selections := selections bitXor: bit.
				(selections bitAnd: 14) isZero ifTrue: [ (document getElementById: #confirmed) checked: true. selections := selections | 2 ].
				self resizeGraphs.
	]]].

]

{ #category : #accessing }
CovidApp >> sorted [
	^ world subdivisionsSortedBy: #name
]

{ #category : #'start-stop' }
CovidApp >> start [
	super start.
	self setupElements.
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

]

{ #category : #displaying }
CovidApp >> toggleGraph: region [
	(graphs includes: region) ifTrue: [
		graphs remove: region.
		region remove.
		graphs ifEmpty: [
			graphsDiv append: faqDiv.
			graphsDiv removeChild: hideDiv.
		].
	] ifFalse: [
		graphs ifEmpty: [
			graphsDiv removeChild: faqDiv.
			graphsDiv append: hideDiv.
		].
		graphs add: region.
		region addTo: graphsDiv.
	].
	graphs ifNotEmpty: [ self resizeGraphs ].

]
