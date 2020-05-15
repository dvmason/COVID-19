"
I have all the data for a particular dataset.

I eventually will be able to smooth my data.

I know how to create a DIV to display myself.
"
Class {
	#name : #CovDataset,
	#superclass : #Object,
	#instVars : [
		'data',
		'smoothed',
		'smoothing',
		'canvas',
		'classList',
		'dayValue',
		'color'
	],
	#pools : [
		'CovGlobals',
		'PjBrowserGlobals'
	],
	#category : #COVID19
}

{ #category : #accessing }
CovDataset >> <= other [
	^ dayValue >= other dayValue
]

{ #category : #updating }
CovDataset >> add: aCovRegion [ 
	1 to: aCovRegion days do: [: i |
		self at: i add: (aCovRegion day: i).
	].

]

{ #category : #updating }
CovDataset >> at: i add: aNumber [
	data size < i ifTrue: [ data add: 0. smoothing add: 0].
	data at: i put: (data at: i)+aNumber.
	smoothing at: i put: 0.
	smoothed := false.


]

{ #category : #accessing }
CovDataset >> color [
	^ color
]

{ #category : #accessing }
CovDataset >> color: aString [
	color := aString.

]

{ #category : #accessing }
CovDataset >> count [
	^ data inject: 0 into: [: sum : each | sum+each ]
]

{ #category : #accessing }
CovDataset >> day: anInteger [
	data size < anInteger ifTrue: [ ^ dayValue := 0 ].
	^ dayValue := (data at: anInteger) + (smoothing at: anInteger)
]

{ #category : #accessing }
CovDataset >> daySum: anInteger [
	dayValue := 0.
	1 to: (data size min: anInteger) do: [: index |
		dayValue := dayValue + (data at: index) + (smoothing at: index).
	].
	^ dayValue
]

{ #category : #accessing }
CovDataset >> dayValue [
	^ dayValue
]

{ #category : #accessing }
CovDataset >> days [
	^ data ifNil: [ 0 ] ifNotNil: [data size]
]

{ #category : #accessing }
CovDataset >> first [
	^ 1 to: data size do: [: i | (self day: i)>0 ifTrue: [ ^ i ]]
]

{ #category : #initialization }
CovDataset >> initialize [
	super initialize.
	smoothed := false.
	data := OrderedCollection new.
	smoothing := OrderedCollection new
]

{ #category : #accessing }
CovDataset >> last [
	data size to: 1 by: -1 do: [: i | (self day: i)>0 ifTrue: [ ^ i ]].
	^ 0
]

{ #category : #accessing }
CovDataset >> max [
	^ (1 to: data size) inject: 0 into: [: maxSoFar : i | maxSoFar max: (self day: i) ]
]

{ #category : #parsing }
CovDataset >> parse: aCollection [ 
	| prev |
	prev := 0.
	aCollection withIndexDo: [: each : i | | val |
		val := each asInteger.
		self at: i add: (0 max: val-prev).
		prev := val.
	].
	smoothed := false.

]

{ #category : #formatting }
CovDataset >> raw [
	smoothed := false.
	1 to: smoothing size do: [: i | smoothing at: i put: 0 ].

]

{ #category : #formatting }
CovDataset >> smooth [
	smoothed ifTrue: [ ^ self ].
	self smooth: 4.

]

{ #category : #formatting }
CovDataset >> smooth: nnDays [
	| n sum first weight |
	smoothed ifTrue: [ ^ self ].
	n := data size.
	1 to: nnDays do: [: nDays |
	first := n.
	weight := 1.0/((1 to: nDays) sum).
	sum := 0.0+ (self day: n).
	n+nDays to: 1 by: -1 do: [: i | | avg delta |
		sum := sum + (self day: first).
		i <= n ifTrue: [
			avg := sum/(i-first+2).
			delta := ((self day: i)-avg) floor.
			delta > 0 ifTrue: [
				smoothing at: i put: (smoothing at: i) - delta.
				first to: (i-1) do: [: j | | d2 |
					d2 := (delta*(j-first+1)*weight) floor.
					smoothing at: j put: (smoothing at: j) + d2.
					delta := delta - d2.
				].
				smoothing at: i put: (smoothing at: i) + delta.
			].
		].
		i < n ifTrue: [ sum := sum - (self day: i+1) ].
		first > 1 ifTrue: [ first := first - 1 ].
	]].
	smoothed := true.

]

{ #category : #accessing }
CovDataset >> sum [
	^ (1 to: data size) inject: 0 into: [: sum : i | sum + (self day: i) ]
]
