"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestCOVID,
	#superclass : #PackageManifest,
	#category : #'COVID19-Manifest'
}

{ #category : #'code-critics' }
ManifestCOVID class >> ruleRBBadMessageRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CovRegion #sortedBy: #false)) #'2020-05-01T13:53:37.183354-04:00') )
]

{ #category : #'code-critics' }
ManifestCOVID class >> ruleRBLongMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CovidApp #parseCSV:with:header: #false)) #'2020-04-27T16:34:18.59924-04:00') #(#(#RGMethodDefinition #(#CovidApp #populate:depth:in:sortBy: #false)) #'2020-04-30T00:57:16.177671-04:00') )
]

{ #category : #'code-critics' }
ManifestCOVID class >> ruleRBSentNotImplementedRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CovidApp #start #false)) #'2020-04-24T16:49:01.167842-04:00') )
]

{ #category : #'code-critics' }
ManifestCOVID class >> ruleRBStringConcatenationRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CovidApp #start #false)) #'2020-04-24T16:42:22.071754-04:00') #(#(#RGMethodDefinition #(#CovidApp #scale: #false)) #'2020-04-24T16:45:24.766796-04:00') #(#(#RGMethodDefinition #(#CovidApp #parseCSV:with:header: #false)) #'2020-04-27T16:34:07.706603-04:00') #(#(#RGMethodDefinition #(#CovidApp #dequote: #false)) #'2020-04-27T16:36:43.905209-04:00') )
]

{ #category : #'code-critics' }
ManifestCOVID class >> ruleRBToDoWithIncrementRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CovidApp #toggleGraph: #false)) #'2020-04-30T23:04:13.050382-04:00') )
]

{ #category : #'code-critics' }
ManifestCOVID class >> ruleRBUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CovidApp #parseCSV:with: #false)) #'2020-04-26T16:47:16.858146-04:00') #(#(#RGMethodDefinition #(#CovidApp #parseCSV:with:header: #false)) #'2020-04-27T16:34:13.659501-04:00') #(#(#RGMethodDefinition #(#CovidApp #dequote: #false)) #'2020-04-27T16:36:48.376404-04:00') )
]
