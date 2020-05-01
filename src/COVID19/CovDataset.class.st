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
		'ctx',
		'canvas'
	],
	#pools : [
		'CovGlobals',
		'PjBrowserGlobals'
	],
	#category : #COVID19
}

{ #category : #updating }
CovDataset >> add: aCovRegion [ 
	1 to: aCovRegion days do: [: i |
		self at: i add: (aCovRegion day: i).
	].

]

{ #category : #updating }
CovDataset >> at: i add: aNumber [
	data ifNil: [ data := OrderedCollection new. smoothing := OrderedCollection new ].
	data size < i ifTrue: [ data add: 0. smoothing add: 0].
	data at: i put: (data at: i)+aNumber.
	smoothing at: i put: 0.
	smoothed := false.


]

{ #category : #accessing }
CovDataset >> canvas [
	canvas ifNil: [ ^ canvas ].
	self smooth.
	canvas := document createElement: #canvas.
	canvas width: data size * 7 + 1.
	canvas height: 100.
	ctx := canvas getContext: '2d'.
	^ canvas
]

{ #category : #accessing }
CovDataset >> count [
	^ data inject: 0 into: [: sum : each | sum+each ]
]

{ #category : #accessing }
CovDataset >> day: anInteger [
	^ (data at: anInteger) + (smoothing at: anInteger)
]

{ #category : #accessing }
CovDataset >> days [
	^ data size
]

{ #category : #initialiation }
CovDataset >> initialize [
	super initialize.
	smoothed := false.


]

{ #category : #parsing }
CovDataset >> parse: aCollection [ 
	| prev |
	prev := 0.
	aCollection withIndexDo: [: each : i | | val |
		val := each asInteger.
		self at: i add: val-prev.
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
	^ self
]
