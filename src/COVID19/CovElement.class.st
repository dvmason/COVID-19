"
I add methods to the HTMLElement DOM class.

"
Class {
	#name : #CovElement,
	#superclass : #Object,
	#instVars : [
		'style'
	],
	#category : #'COVID19-Kernel'
}

{ #category : #'pharoJs support' }
CovElement class >> javascriptName [
	<pharoJsSkip>
	^ 'HTMLElementXXX'
]

{ #category : #initialization }
CovElement >> setScale: aNumber [
	style transform: 'scale(',aNumber asString,')'.

]
