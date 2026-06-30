Class {
	#name : 'SCOPEOTraceRecorder',
	#superclass : 'EchoTraceRecorder',
	#category : 'Echo-Model',
	#package : 'Echo',
	#tag : 'Model'
}

{ #category : 'executing' }
SCOPEOTraceRecorder >> execute [

	self initializeOriginalRecorder .
	self initializeModifiedRecorder .

	self executeOriginal.
	self executeModified.
	"on doit attendre la fin du process de scopeo"

	
	^ self
]

{ #category : 'as yet unclassified' }
SCOPEOTraceRecorder >> executeModified [

	modifiedTrace := modifiedRecorder traces.
]

{ #category : 'as yet unclassified' }
SCOPEOTraceRecorder >> executeOriginal [

	originalTrace := originalRecorder traces .
]

{ #category : 'initialization' }
SCOPEOTraceRecorder >> initializeModifiedRecorder [

	modifiedRecorder := ScpExecutionRecorder 
		                    recordBlock: modified as: ScpExecutionRecordList
]

{ #category : 'initialization' }
SCOPEOTraceRecorder >> initializeOriginalRecorder [

	originalRecorder := ScpExecutionRecorder 
		                    recordBlock: original as: ScpExecutionRecordList
]
