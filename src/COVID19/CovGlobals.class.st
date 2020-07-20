"
I have the browser globals that are needed by this application beyond what is provided by PjBrowserGlobals

I also define some methods so the code critic doesn't complain.
They are defined on the class side, and will be skipped in transpilation.
"
Class {
	#name : #CovGlobals,
	#superclass : #PjJavascriptGlobals,
	#traits : 'PjTJavascriptGlobalsInitializer',
	#classTraits : 'PjTJavascriptGlobalsInitializer classTrait',
	#classVars : [
		'TextDecoder',
		'TextEncoder'
	],
	#category : #'COVID19-Kernel'
}

{ #category : #'code-critics' }
CovGlobals class >> appendChild: aNode [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> classList: aString [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> clearRect: x y: y width: width height: height [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> cloneNode [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> createTextNode: aString [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> fillRect: x y: y width: width height: height [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> fillText: aString x: x y: y [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> getBoundingClientRect [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> getReader [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> innerHTML: aString [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> innerText: aString [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> keyCode [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> log: s1 with: s2 [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> log: s1 with: s2 with: s3 [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> log: s1 with: s2 with: s3 with: s4 [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> log: s1 with: s2 with: s3 with: s4 with: s5 [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> log: s1 with: s2 with: s3 with: s4 with: s5 with: s6 [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> log: s1 with: s2 with: s3 with: s4 with: s5 with: s6 with: s7 [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> log: s1 with: s2 with: s3 with: s4 with: s5 with: s6 with: s7 with: s8 [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> log: s1 with: s2 with: s3 with: s4 with: s5 with: s6 with: s7 with: s8 with: s9 [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> log: s1 with: s2 with: s3 with: s4 with: s5 with: s6 with: s7 with: s8 with: s9 with: s10 [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> offsetHeight [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> offsetWidth [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> replaceChild: aNode for: bNode [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> stopPropagation [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> textAlign: aString [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> then: aBlock [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> toLocaleString [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> toggle: aString [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]

{ #category : #'code-critics' }
CovGlobals class >> translate: x y: y [
	<pharoJsSkip>
	" this is a dummy to appease the code critic "
]
