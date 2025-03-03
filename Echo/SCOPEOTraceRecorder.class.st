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
	1halt.
	self modifyPosition .
	
	^ self
]

{ #category : 'as yet unclassified' }
SCOPEOTraceRecorder >> executeModified [

	modifiedTrace := modifiedRecorder execution traces.
]

{ #category : 'as yet unclassified' }
SCOPEOTraceRecorder >> executeOriginal [

	originalTrace := originalRecorder execution traces .
]

{ #category : 'initialization' }
SCOPEOTraceRecorder >> initializeModifiedRecorder [

	modifiedRecorder := ScpExecutionRecorder new
		                    recordBlock: modified;
		                    yourself
]

{ #category : 'initialization' }
SCOPEOTraceRecorder >> initializeOriginalRecorder [

	originalRecorder := ScpExecutionRecorder new
		                    recordBlock: original;
		                    yourself
]

{ #category : 'as yet unclassified' }
SCOPEOTraceRecorder >> modifyPosition [

	| position |
	
	position := 1.
	originalTrace do: [ :a | a position: position. position := position + 1  ].
	position := 1.
	modifiedTrace do: [ :a | a position: position. position := position + 1  ].
]
