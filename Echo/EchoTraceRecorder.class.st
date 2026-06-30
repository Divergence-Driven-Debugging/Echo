Class {
	#name : 'EchoTraceRecorder',
	#superclass : 'Object',
	#instVars : [
		'original',
		'modified',
		'originalRecorder',
		'modifiedRecorder',
		'originalTrace',
		'modifiedTrace',
		'packages'
	],
	#category : 'Echo-Model',
	#package : 'Echo',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
EchoTraceRecorder class >> original: original modified: modified [

	^ self new
	original: original;
	modified: modified;
	yourself 
]

{ #category : 'accessing' }
EchoTraceRecorder >> modified [

	^ modified
]

{ #category : 'accessing' }
EchoTraceRecorder >> modified: anObject [

	modified := anObject
]

{ #category : 'accessing' }
EchoTraceRecorder >> modifiedRecorder [

	^ modifiedRecorder
]

{ #category : 'accessing' }
EchoTraceRecorder >> modifiedRecorder: anObject [

	modifiedRecorder := anObject
]

{ #category : 'accessing' }
EchoTraceRecorder >> modifiedTrace [

	^ modifiedTrace
]

{ #category : 'accessing' }
EchoTraceRecorder >> modifiedTrace: anObject [

	modifiedTrace := anObject
]

{ #category : 'accessing' }
EchoTraceRecorder >> original [

	^ original
]

{ #category : 'accessing' }
EchoTraceRecorder >> original: anObject [

	original := anObject
]

{ #category : 'accessing' }
EchoTraceRecorder >> originalRecorder [

	^ originalRecorder
]

{ #category : 'accessing' }
EchoTraceRecorder >> originalRecorder: anObject [

	originalRecorder := anObject
]

{ #category : 'accessing' }
EchoTraceRecorder >> originalTrace [

	^ originalTrace
]

{ #category : 'accessing' }
EchoTraceRecorder >> originalTrace: anObject [

	originalTrace := anObject
]

{ #category : 'accessing' }
EchoTraceRecorder >> packages [

	^ packages
]

{ #category : 'accessing' }
EchoTraceRecorder >> packages: aCollectionOfPackages [

	packages := aCollectionOfPackages 
]
