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
		'currentDataset'
	],
	#pools : [
		'PjBrowserGlobals'
	],
	#category : #COVID19
}

{ #category : #sorting }
CovRegion >> <= other [
	sortBy isNumber ifTrue: [ ^ other sortBy <= sortBy ].
	^ sortBy <= other sortBy
]

{ #category : #displaying }
CovRegion >> addTo: aDiv [
	aDiv append: self div.

]

{ #category : #accessing }
CovRegion >> confirmed [
	^ confirmed ifNil: [
			confirmed := CovDataset new.
			subdivisions ifNotNil: [
				subdivisions valuesDo: [: sub | confirmed add: sub confirmed]
			].
			confirmed
		]
]

{ #category : #sorting }
CovRegion >> confirmedPerCapSort [
	confirmed ifNil: [ subdivisions ifNil: [ ^ nil ]].
	population ifNil: [ ^ nil ].
	currentDataset := self confirmed.
	sortBy := (1000000 * confirmed count / population) asInteger.
	sortBy isZero ifTrue: [ ^ nil ].
	self setCount: sortBy.

]

{ #category : #sorting }
CovRegion >> confirmedSort [
	confirmed ifNil: [ subdivisions ifNil: [ ^ nil ]].
	currentDataset := self confirmed.
	sortBy := confirmed count.
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
			deaths := CovDataset new.
			subdivisions ifNotNil: [
				subdivisions valuesDo: [: sub | deaths add: sub deaths]
			].
			deaths
		]
]

{ #category : #sorting }
CovRegion >> deathsPerCapSort [
	deaths ifNil: [ subdivisions ifNil: [ ^ nil ]].
	population ifNil: [ ^ nil ].
	currentDataset := self deaths.
	sortBy := (1000000 * deaths count / population) asInteger.
	sortBy isZero ifTrue: [ ^ nil ].
	self setCount: sortBy.

]

{ #category : #sorting }
CovRegion >> deathsSort [
	deaths ifNil: [ subdivisions ifNil: [ ^ nil ]].
	currentDataset := self deaths.
	sortBy := deaths count.
	sortBy isZero ifTrue: [ ^ nil ].
	self setCount: sortBy.

]

{ #category : #displaying }
CovRegion >> div [

]

{ #category : #displaying }
CovRegion >> divWithTitle: aString [
	currentDataset ifNil: [ ^ nil ].
	^ currentDataset divWithTitle: aString
]

{ #category : #accessing }
CovRegion >> hasConfirmed [
	^ confirmed isNotNil
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
	currentDataset ifNil: [ currentDataset := self confirmed ].
	sortBy := name.
	self setCount: population.

]

{ #category : #parsing }
CovRegion >> parse: aCollection as: aSymbol [
	(self perform: aSymbol) parse: aCollection.

]

{ #category : #sorting }
CovRegion >> populationSort [
	population ifNil: [ ^ nil ].
	currentDataset ifNil: [ currentDataset := self confirmed ].
	sortBy := population.
	self setCount: sortBy.

]

{ #category : #accessing }
CovRegion >> recovered [
	^ recovered ifNil: [
			recovered := CovDataset new.
			subdivisions ifNotNil: [
				subdivisions valuesDo: [: sub | recovered add: sub recovered]
			].
			recovered
		]
]

{ #category : #sorting }
CovRegion >> recoveredPerCapSort [
	recovered ifNil: [ subdivisions ifNil: [ ^ nil ]].
	population ifNil: [ ^ nil ].
	currentDataset := self recovered.
	sortBy := (1000000 * recovered count / population) asInteger.
	sortBy isZero ifTrue: [ ^ nil ].
	self setCount: sortBy.

]

{ #category : #sorting }
CovRegion >> recoveredSort [
	recovered ifNil: [ subdivisions ifNil: [ ^ nil ]].
	currentDataset := self recovered.
	sortBy := recovered count.
	sortBy isZero ifTrue: [ ^ nil ].
	self setCount: sortBy.

]

{ #category : #displaying }
CovRegion >> scale: scale row: row of: nrows col: col of: ncols [
	| div |
	div := currentDataset div.
	div style transform: 'scale(',scale asString,')'.
	
]

{ #category : #sorting }
CovRegion >> setCount: value [
	countDiv ifNotNil: [ countDiv innerText: (value ifNil: ['']) ].

]

{ #category : #accessing }
CovRegion >> setPopulation: populations [
	| lookup |
	populations at: name ifPresent: [lookup := name] ifAbsent: [
		populations keysDo: [: key |
			(key first: 3) = (name first: 3) ifTrue: [
				lookup ifNil: [ lookup := key ] "ifNotNil: [ console log: name with: key with: lookup ]"
			]
		]
	].
	populations at: lookup ifPresent: [ : assoc |
		population := assoc value.
	].
	self subdivisions do: [: sub | sub setPopulation: populations ].

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
