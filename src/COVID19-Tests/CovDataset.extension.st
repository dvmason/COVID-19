Extension { #name : #CovDataset }

{ #category : #'*COVID19-Tests' }
CovDataset >> smoothed [
	^ (1 to: data size) collect: [: i | (self day: i) asInteger ]
]
