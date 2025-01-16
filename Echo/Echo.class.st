Class {
	#name : 'Echo',
	#superclass : 'Object',
	#instVars : [
		'packages',
		'modified',
		'original',
		'originalInterpreter',
		'modifiedInterpreter'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'executing' }
Echo >> analyse: programmState [

	| result analyse |
	result := OrderedCollection new.
	analyse := EchoAnalyse new.

	result add: programmState originalProgState.
	result add: programmState modifiedProgState.
	result add: (analyse analyseDiv: programmState).
	^ result
]

{ #category : 'executing' }
Echo >> execute [


	| programmState   |

"	1halt."
	programmState := EchoCollectionState new.
	originalInterpreter := DASTInterpreter new.
	originalInterpreter initializeWithProgram: ((RBParser parseExpression: original)).
	modifiedInterpreter := DASTInterpreter new.
	modifiedInterpreter initializeWithProgram: ((RBParser parseExpression: modified)).
	programmState original: originalInterpreter modified: modifiedInterpreter . 
"	1halt ."
	[ originalInterpreter isTerminated not or: [modifiedInterpreter  isTerminated not ]] whileTrue: [ 
	"algo algoDiff."
	('je suis au pc ' ,  originalInterpreter programCounter asString ) traceCr.
	1 haltIf: [ originalInterpreter programCounter = 600000 ].
	self step.
	programmState collect].

	^ self analyse: programmState


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

{ #category : 'executing' }
Echo >> step [

	originalInterpreter isTerminated ifFalse: [ originalInterpreter stepInto ].

	modifiedInterpreter isTerminated ifFalse: [ modifiedInterpreter stepInto ]
]

{ #category : 'executing' }
Echo >> stepTo: aGoodProgramCounter bad: aBadProgramCounter [

	[originalInterpreter programCounter < aGoodProgramCounter] whileTrue: [ 
		originalInterpreter stepInto ].
	[modifiedInterpreter programCounter < aBadProgramCounter] whileTrue: [ 
		modifiedInterpreter stepInto ].
^ OrderedCollection new add: originalInterpreter ; add: modifiedInterpreter ; yourself

]

{ #category : 'executing' }
Echo >> stepTo: aGoodProgramCounter modified: aBadProgramCounter [

	[originalInterpreter programCounter < aGoodProgramCounter] whileTrue: [ 
		originalInterpreter stepInto ].
	[modifiedInterpreter programCounter < aBadProgramCounter] whileTrue: [ 
		modifiedInterpreter stepInto ].
^ OrderedCollection new add: originalInterpreter ; add: modifiedInterpreter ; yourself

]

{ #category : 'executing' }
Echo >> timeTravelGood: aGoodProgramCounter bad: aBadProgramCounter [

	originalInterpreter := DASTInterpreter new.
	originalInterpreter initializeWithProgram: ((RBParser parseExpression: original)).
	modifiedInterpreter := DASTInterpreter new.
	modifiedInterpreter initializeWithProgram: ((RBParser parseExpression: modified)). 
   ^ self stepTo: aGoodProgramCounter bad:aBadProgramCounter


]

{ #category : 'executing' }
Echo >> timeTravelGood: aGoodProgramCounter modified: aBadProgramCounter [

	originalInterpreter := DASTInterpreter new.
	originalInterpreter initializeWithProgram: ((RBParser parseExpression: original)).
	modifiedInterpreter := DASTInterpreter new.
	modifiedInterpreter initializeWithProgram: ((RBParser parseExpression: modified)). 
   ^ self stepTo: aGoodProgramCounter modified:aBadProgramCounter


]
