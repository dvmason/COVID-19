"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestCOVID,
	#superclass : #PackageManifest,
	#category : #'COVID19-Manifest'
}

{ #category : #'code-critics' }
ManifestCOVID class >> ruleGRTemporaryNeitherReadNorWrittenRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CovRegion #graph:step:start:from:to: #false)) #'2020-05-08T15:44:21.594905-04:00') )
]

{ #category : #'code-critics' }
ManifestCOVID class >> ruleRBBadMessageRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CovRegion #sortedBy: #false)) #'2020-05-01T13:53:37.183354-04:00') )
]

{ #category : #'code-critics' }
ManifestCOVID class >> ruleRBExcessiveArgumentsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CovRegion #graph:step:start:from:to: #false)) #'2020-05-08T14:57:30.571261-04:00') #(#(#RGMethodDefinition #(#CovRegion #graph:step:per:start:from:to: #false)) #'2020-05-08T17:53:23.435296-04:00') )
]

{ #category : #'code-critics' }
ManifestCOVID class >> ruleRBLongMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CovidApp #parseCSV:with:header: #false)) #'2020-04-27T16:34:18.59924-04:00') #(#(#RGMethodDefinition #(#CovidApp #populate:depth:in:sortBy: #false)) #'2020-04-30T00:57:16.177671-04:00') #(#(#RGMethodDefinition #(#CovidApp #setupElements #false)) #'2020-05-06T15:54:57.202137-04:00') #(#(#RGMethodDefinition #(#CovidApp #initialize #false)) #'2020-05-06T23:46:19.168981-04:00') #(#(#RGMethodDefinition #(#CovidApp #parse:as:isUS: #false)) #'2020-05-07T16:38:19.643485-04:00') #(#(#RGMethodDefinition #(#CovRegion #graph:start:ratio: #false)) #'2020-05-08T12:29:55.61784-04:00') #(#(#RGMethodDefinition #(#CovRegion #graph:start:from:to: #false)) #'2020-05-08T13:31:14.533785-04:00') #(#(#RGMethodDefinition #(#CovRegion #graph:step:start:from:to: #false)) #'2020-05-08T14:56:33.978059-04:00') #(#(#RGMethodDefinition #(#CovidApp #resizeGraphs #false)) #'2020-05-08T17:04:44.171524-04:00') #(#(#RGMethodDefinition #(#CovRegion #graph:step:per:start:from:to: #false)) #'2020-05-08T17:53:16.98191-04:00') #(#(#RGMethodDefinition #(#CovDataset #smooth: #false)) #'2020-05-10T17:51:44.503332-04:00') )
]

{ #category : #'code-critics' }
ManifestCOVID class >> ruleRBSentNotImplementedRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CovidApp #start #false)) #'2020-04-24T16:49:01.167842-04:00') )
]

{ #category : #'code-critics' }
ManifestCOVID class >> ruleRBStringConcatenationRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CovidApp #start #false)) #'2020-04-24T16:42:22.071754-04:00') #(#(#RGMethodDefinition #(#CovidApp #scale: #false)) #'2020-04-24T16:45:24.766796-04:00') #(#(#RGMethodDefinition #(#CovidApp #parseCSV:with:header: #false)) #'2020-04-27T16:34:07.706603-04:00') #(#(#RGMethodDefinition #(#CovidApp #dequote: #false)) #'2020-04-27T16:36:43.905209-04:00') #(#(#RGMethodDefinition #(#CovidApp #setupElements #false)) #'2020-05-13T15:35:36.630931-04:00') )
]

{ #category : #'code-critics' }
ManifestCOVID class >> ruleRBTempsReadBeforeWrittenRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CovRegion #graph:start:ratio: #false)) #'2020-05-08T12:29:50.49824-04:00') #(#(#RGMethodDefinition #(#CovRegion #graph:start:from:to: #false)) #'2020-05-08T13:31:09.933018-04:00') #(#(#RGMethodDefinition #(#CovRegion #graph:step:start:from:to: #false)) #'2020-05-08T15:40:44.66078-04:00') #(#(#RGMethodDefinition #(#CovRegion #graph:step:per:start:from:to: #false)) #'2020-05-08T20:36:01.88704-04:00') )
]

{ #category : #'code-critics' }
ManifestCOVID class >> ruleRBToDoWithIncrementRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CovidApp #toggleGraph: #false)) #'2020-04-30T23:04:13.050382-04:00') )
]

{ #category : #'code-critics' }
ManifestCOVID class >> ruleRBUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CovidApp #parseCSV:with: #false)) #'2020-04-26T16:47:16.858146-04:00') #(#(#RGMethodDefinition #(#CovidApp #parseCSV:with:header: #false)) #'2020-04-27T16:34:13.659501-04:00') #(#(#RGMethodDefinition #(#CovidApp #dequote: #false)) #'2020-04-27T16:36:48.376404-04:00') )
]
