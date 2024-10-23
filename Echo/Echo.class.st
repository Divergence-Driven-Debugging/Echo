Class {
	#name : 'Echo',
	#superclass : 'Object',
	#instVars : [
		'good',
		'bad',
		'interpreterGood',
		'interpreterBad',
		'packages',
		'algo'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
Echo >> analyseDiv: programmState [

	| asDiv messageDiv creationInstanceDiv |
	1halt.
	asDiv := self assignementDiv: programmState.
	messageDiv := self messageDiv: programmState.
	"creationInstanceDiv := self creationInstanceDiv: programmState."

	asDiv do: [ :c |
		'Divergence on assignement' traceCr.
		'' traceCr.
		'programm counter is equivalent on this node :' traceCr.
		(c at: 3) traceCr.
		'node is equivalent on this node :' traceCr.
		(c at: 4) traceCr ].
	messageDiv do: [ :c |
		'' traceCr.
		'Divergence on message' traceCr.
		'' traceCr.
		'programm counter is equivalent on this node :' traceCr.
		(c at: 3) traceCr.
		'node is equivalent on this node :' traceCr.
		(c at: 4) traceCr ].
	1 halt.
	^ asDiv
]

{ #category : 'as yet unclassified' }
Echo >> assignementDiv: programmState [

	| goodState badState ttqGood solveGood ttqBad badSolve r assGood assBad r1 size |
	goodState := programmState goodProgState.
	badState := programmState badProgState.


	ttqGood := TTQAllAssignments queryFrom: goodState.
	solveGood := QSCollection solve: ttqGood.

	ttqBad := TTQAllAssignments queryFrom: badState.
	badSolve := QSCollection solve: ttqBad.

	r := OrderedCollection new.
	size := solveGood size max: badSolve size.
	1 to: size do: [ :a |
		assGood := solveGood at: a ifAbsent: [ DASTGoodMissing new ].
		assBad := badSolve at: a ifAbsent: [ DASTBadMissing new ].
		(assGood programCounter = assBad programCounter and: [
			 assGood node isEquivalentTo: assBad node ]) ifFalse: [
			r1 := OrderedCollection new.
			r1 add: assGood.
			r1 add: assBad.
			r1 add: assGood programCounter = assBad programCounter.
			r1 add: (assGood node isEquivalentTo: assBad node).
			r add: r1 ] ].


	^ r
]

{ #category : 'accessing' }
Echo >> bad [

	^ bad
]

{ #category : 'accessing' }
Echo >> bad: anObject [

	bad := anObject
]

{ #category : 'as yet unclassified' }
Echo >> creationInstanceDiv: programmState [

	| goodState badState ttqGood solveGood ttqBad badSolve r assGood assBad r1 size |
	goodState := programmState goodProgState.
	badState := programmState badProgState.

	1halt.
	ttqGood := TTQAllInstanceCreations queryFrom: goodState.
	solveGood := QSCollection solve: ttqGood.

	ttqBad := TTQAllInstanceCreations queryFrom: badState.
	badSolve := QSCollection solve: ttqBad.

	r := OrderedCollection new.
	size :=  (solveGood size) max:( badSolve size). 
	1 to: size do: [ :a |
		assGood := solveGood at: a ifAbsent: [DASTGoodMissing new].
		assBad := badSolve at: a ifAbsent: [DASTBadMissing new].
		r1 := OrderedCollection new.
		r1 add: assGood.
		r1 add: assBad.
		r1 add: assGood programCounter = assBad programCounter.
		r1 add: (assGood node isEquivalentTo: assBad node).
		r add: r1 ].
	^ r
]

{ #category : 'executing' }
Echo >> execute [


	| programmState |
"	1halt."
	programmState := EchoCollectionState new.
	interpreterGood := DASTInterpreter new.
	interpreterGood initializeWithProgram: ((RBParser parseExpression: good)).
	interpreterBad := DASTInterpreter new.
	interpreterBad initializeWithProgram: ((RBParser parseExpression: bad)).
	programmState good: interpreterGood bad: interpreterBad . 
	algo good: interpreterGood bad: interpreterBad .
"	1halt ."
	[ interpreterGood isTerminated not or: [interpreterBad  isTerminated not ]] whileTrue: [ 
	"algo algoDiff."
	self step.
	programmState collect].
	^ self analyseDiv: programmState 

]

{ #category : 'accessing' }
Echo >> good [

	^ good
]

{ #category : 'accessing' }
Echo >> good: anObject [

	good := anObject
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

{ #category : 'initialization' }
Echo >> initialize [ 

	algo := EchoAlgo new.

]

{ #category : 'as yet unclassified' }
Echo >> messageDiv: programmState [

	| goodState badState ttqGood solveGood ttqBad badSolve r assGood assBad r1 size |
	goodState := programmState goodProgState.
	badState := programmState badProgState.


	ttqGood := TTQAllMessage queryFrom: goodState.
	solveGood := QSCollection solve: ttqGood.

	ttqBad := TTQAllMessage queryFrom: badState.
	badSolve := QSCollection solve: ttqBad.
	

	r := OrderedCollection new.
	size := solveGood size max: badSolve size.
	1 to: size do: [ :a |
		assGood := solveGood at: a ifAbsent: [ DASTGoodMissing new ].
		assBad := badSolve at: a ifAbsent: [ DASTBadMissing new ].
		(assGood programCounter = assBad programCounter and: [
			 assGood node isEquivalentTo: assBad node ]) ifFalse: [
			r1 := OrderedCollection new.
			r1 add: assGood.
			r1 add: assBad.
			r1 add: assGood programCounter = assBad programCounter.
			r1 add: (assGood node isEquivalentTo: assBad node).
			r add: r1 ] ].


	^ r
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

	interpreterGood isTerminated ifFalse: [
		((self packages includes: interpreterGood receiver package) or: [
			 interpreterGood receiver = nil ])
			ifTrue: [ interpreterGood stepInto ]
			ifFalse: [ interpreterGood stepOver ] ].

	interpreterBad isTerminated ifFalse: [
		((self packages includes: interpreterBad receiver package) or: [
			 interpreterBad receiver = nil ])
			ifTrue: [ interpreterBad stepInto ]
			ifFalse: [ interpreterBad stepOver ] ]
]
