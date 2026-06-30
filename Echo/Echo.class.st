Class {
	#name : 'Echo',
	#superclass : 'Object',
	#instVars : [
		'packages',
		'modified',
		'original',
		'recorder',
		'historyOfObjectOrigin',
		'historyOfObjectModified',
		'currentHistory'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'executing' }
Echo >> analyse [

	| result analyse |
	analyse := EchoAnalyse new.
	analyse objectHistoryOrigin: self historyOfObjectOrigin  modified: historyOfObjectModified .



	result := (analyse analyseDiv: recorder).
		result referenceStack: (recorder originalTrace).
	result modifiedStack: (recorder modifiedTrace) .
	result updateDivergence .
	^ result
]

{ #category : 'accessing' }
Echo >> currentHistory [

	^ currentHistory
]

{ #category : 'accessing' }
Echo >> currentHistory: anObject [

	currentHistory := anObject
]

{ #category : 'serializing' }
Echo >> deserialize: aFileNameOriginal v2: aFileNameModified [

	| reader data traces dataM tracesM |
	data := OrderedCollection new.
	traces := OrderedCollection new.
	
	historyOfObjectOrigin := Dictionary new.
	self currentHistory: historyOfObjectOrigin.

	(FileLocator downloads / aFileNameOriginal) asFileReference readStreamDo: [
		:stream |
		reader := STONReader on: stream.
		[ reader atEnd ] whileFalse: [ data add: reader next ] ].
	data do: [ :t | traces add: (self deserializeTraces: t) ].
	original := traces.
	
	
	dataM := OrderedCollection new.
	tracesM := OrderedCollection new.
	 
	historyOfObjectModified := Dictionary new.
   self currentHistory: historyOfObjectModified.

	(FileLocator downloads / aFileNameModified ) asFileReference readStreamDo: [
		:stream |
		reader := STONReader on: stream.
		[ reader atEnd ] whileFalse: [ dataM add: reader next ] ].
	dataM do: [ :t | tracesM add: (self deserializeTraces: t) ].
	modified := tracesM.
	

	recorder := SCOPEOTraceRecorder new
		            modifiedTrace: modified;
		            originalTrace: original;
		            yourself.


]

{ #category : 'deserialize' }
Echo >> deserializeAssignementTraces: aDictionary [ 

| object |

	aDictionary at: 'object' at: 'timeStamp' ifAbsentPut: [aDictionary at: 'timeStamp'].
	object := self deserializeObjectAssignement: (aDictionary at: 'object').
	object actualiseHistory: aDictionary.
	^ ScpAssignmentTrace new timestamp: (aDictionary at: 'timeStamp');
	variable: (aDictionary at: 'variable');
	oldValue: (aDictionary at: 'old value');
	newValue: (aDictionary at: 'new value');
	object: (aDictionary at: 'object');
	node: (RBNodeSerializeScopeo new
				   sourceCode: (aDictionary at: 'codeSource');
				   name: (aDictionary at: 'name');
				   yourself);
	
	yourself .
]

{ #category : 'deserialize' }
Echo >> deserializeMessageTraces: aDictionary [

	| receiver object |
	receiver := self deserializeObject: (aDictionary at: 'receiver').
	object := self deserializeObject: (aDictionary at: 'sender').
	^ ScpMessageTrace new
		  timestamp: (aDictionary at: 'timeStamp');
		  object: object;
		  receiver: receiver;
		  node: (RBNodeSerializeScopeo new
				   sourceCode: (aDictionary at: 'codeSource');
				   name: (aDictionary at: 'name');
				   yourself);
		  children: ((aDictionary at: 'children') collect: [ :c |
				   self deserializeTraces: c ]);
		  yourself
]

{ #category : 'deserialize' }
Echo >> deserializeMethodTraces: aDictionary [

	| object sender |
	object := self deserializeObject: (aDictionary at: 'receiver').
	sender := self deserializeObject: (aDictionary at: 'sender').
	^ ScpMethodTrace new
		  timestamp: (aDictionary at: 'timeStamp');
		  sender: sender;
		  object: object;
		  node: (RBNodeSerializeScopeo new
				   sourceCode: (aDictionary at: 'codeSource');
				   name: (aDictionary at: 'name');
				   yourself);
		  children: ((aDictionary at: 'children') collect: [ :c |
				   self deserializeTraces: c ]);
		  yourself
]

{ #category : 'deserialize' }
Echo >> deserializeObject: aDictionary [

	| object |

	object := ObjectHistrory new
		          className: (aDictionary at: 'className');
		          hashId: (aDictionary at: 'hash');
		          yourself.
	self currentHistory at: (aDictionary at: 'hash') ifAbsentPut: [ object ].

	object := self currentHistory  at: (aDictionary at: 'hash').

	object dictionaryHistory ifNil: [
		object dictionaryHistory: Dictionary new ]  .
	
	^ object
	

]

{ #category : 'deserialize' }
Echo >> deserializeObjectAssignement: aDictionary [

	| object |
	object := ObjectHistrory new
		          className: (aDictionary at: 'className');
		          hashId: (aDictionary at: 'hash');
		          yourself.
	self currentHistory at: (aDictionary at: 'hash') ifAbsentPut: [ object ].

	object := self currentHistory at: (aDictionary at: 'hash').

	object dictionaryHistory ifNil: [
		object dictionaryHistory: Dictionary new ]  .
	
	^ object
]

{ #category : 'deserialize' }
Echo >> deserializeTraces: aDictionnary [

|traces|

	(aDictionnary includesKey: 'method') ifTrue: [
		traces := self deserializeMethodTraces: aDictionnary ].
	(aDictionnary includesKey: 'assignement') ifTrue: [
		traces := self deserializeAssignementTraces: aDictionnary ].
	(aDictionnary includesKey: 'message') ifTrue: [
		traces := self deserializeMessageTraces: aDictionnary ].
	^ traces
	
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

{ #category : 'accessing' }
Echo >> historyOfObjectModified [

	^ historyOfObjectModified
]

{ #category : 'accessing' }
Echo >> historyOfObjectModified: anObject [

	historyOfObjectModified := anObject
]

{ #category : 'accessing' }
Echo >> historyOfObjectOrigin [

	^ historyOfObjectOrigin
]

{ #category : 'accessing' }
Echo >> historyOfObjectOrigin: anObject [

	historyOfObjectOrigin := anObject
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

{ #category : 'accessing' }
Echo >> recorder [

	^ recorder
]

{ #category : 'accessing' }
Echo >> recorder: anObject [

	recorder := anObject
]
