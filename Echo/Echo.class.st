Class {
	#name : 'Echo',
	#superclass : 'Object',
	#instVars : [
		'packages',
		'modified',
		'original',
		'recorder'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'executing' }
Echo >> analyse [

	| result analyse |
	result := OrderedCollection new.
	analyse := EchoAnalyse new.

	result add: recorder originalTrace.
	result add: recorder modifiedTrace .
	result add: (analyse analyseDiv: recorder).
	^ result
]

{ #category : 'executing' }
Echo >> execute [

	 | analyse |
	 "	1halt.""programmState := EchoCollectionState new.
	originalInterpreter := DASTInterpreter new.
	originalInterpreter initializeWithProgram: ((RBParser parseExpression: original)).
	modifiedInterpreter := DASTInterpreter new.
	modifiedInterpreter initializeWithProgram: ((RBParser parseExpression: modified)).
	programmState original: originalInterpreter modified: modifiedInterpreter . 
	
	[ originalInterpreter isTerminated not or: [modifiedInterpreter  isTerminated not ]] whileTrue: [ 
	('je suis au pc ' ,  originalInterpreter programCounter asString ) traceCr.
	1 haltIf: [ originalInterpreter programCounter = 600000 ].
	self step.
	programmState collect]."
	 recorder := SCOPEOTraceRecorder
		             original: original
		             modified: modified.
	 recorder packages: packages.
	 recorder execute.
	 analyse := self analyse.
	 ^ EchoResult new
		   referenceStack: analyse first;
		   modifiedStack: analyse second;
		   divergences: analyse last;
		   yourself
]

{ #category : 'as yet unclassified' }
Echo >> importBadRepository: aString baseline: aStringBaseline [

	EchoLoader new
		repository: aString;
		baseline: aStringBaseline;
		loadBad .
]

{ #category : 'as yet unclassified' }
Echo >> importGoodRepository: aString baseline: aStringBaseline [

	EchoLoader new
		repository: aString;
		baseline: aStringBaseline;
		loadGood .
]

{ #category : 'accessing' }
Echo >> modified [

	^ modified
]

{ #category : 'accessing' }
Echo >> modified: anObject [

	modified := anObject
]

{ #category : 'accessing' }
Echo >> original [

	^ original
]

{ #category : 'accessing' }
Echo >> original: anObject [

	original := anObject
]

{ #category : 'accessing' }
Echo >> packages [
	
	^ packages
]

{ #category : 'accessing' }
Echo >> packages: anObject [

	packages := anObject
]
