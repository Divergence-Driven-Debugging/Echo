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

	| asDiv messageDiv creationInstanceDiv result|

	result := OrderedCollection new.
	asDiv := self assignementDiv: programmState.
	messageDiv := self messageDiv: programmState.
	"creationInstanceDiv := self creationInstanceDiv: programmState."
	result addAll: messageDiv .
	result addAll: asDiv .
	^ result
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
	
	^ self divergenceAssignementGood: solveGood bad: badSolve result: r shift: 0.
	
	"size := solveGood size max: badSolve size.
	1 to: size do: [ :a |
		assGood := solveGood at: a ifAbsent: [ DASTGoodMissing new ].
		assBad := badSolve at: a ifAbsent: [ DASTBadMissing new ].
		(assGood programCounter = assBad programCounter and: [
			 assGood node isEquivalentTo: assBad node ]) ifFalse: [ 1halt.
			assGoodReconv := badSolve select: [ :ps |ps node isEquivalentTo: assGood node ] first.
			assBadReconv := (solveGood select: [ :ps |ps node isEquivalentTo: assBad node ] first).
			r1 := EchoDivergenceAssign reference: assGood modified: assBad.

			r add: r1 ] ].


	^ r"
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

{ #category : 'as yet unclassified' }
Echo >> divergenceAssignementGood: solveGood bad: solveBad result: result shift: baseShift [

	| assGood assBad reconvGood reconvBad shift |
	1halt.
	shift := 0.
	[ solveGood isNotEmpty or: [ solveBad isNotEmpty ] ] whileTrue: [
		assGood := solveGood at: 1 ifAbsent: [ DASTGoodMissing new ].
		assBad := solveBad at: 1 ifAbsent: [ DASTBadMissing new ].
		(assGood programCounter - baseShift = assBad programCounter and: [
			 assGood node isEquivalentTo: assBad node ]) ifTrue: [ solveGood remove: assGood.
			solveBad remove: assBad ] ifFalse: [
			(assGood node isEquivalentTo: assBad node)
				ifTrue: [
					result add: (EchoDivergenceAssign
							 reference: assGood
							 modified: assBad
							 flow: true
							 state: false).
					solveBad remove: assBad.
					solveGood remove: assGood.
					self
						divergenceAssignementGood: solveGood
						bad: solveBad
						result: result
						shift: assGood programCounter - assBad programCounter ]
				ifFalse: [
					reconvGood := (solveBad select:
						              [ :ps | ps node isEquivalentTo: assGood node ])
							              at: 1 ifAbsent: [ nil ] .
					reconvBad := (solveGood select:
						             [ :ps | ps node isEquivalentTo: assBad node ] )at: 1 ifAbsent: [ nil ].
					reconvGood
						ifNil: [
							result add:  (EchoDivergenceAssign
								reference: assGood 
								modified:  DASTBadMissing new 
								flow: true
								state: true) .
								solveGood remove: assGood ]
						ifNotNil: [
							result add: (EchoDivergenceAssign
								reference: assGood
								modified: reconvGood
								flow: true
								state: false).
							solveGood remove: assGood.
							solveBad remove: reconvGood.
							shift := shift max:
								         assGood programCounter - reconvGood programCounter ].
					reconvBad
						ifNil: [
							result add: (EchoDivergenceAssign
								reference: DASTGoodMissing new
								modified:  assBad 
								flow: true
								state: true ).
								solveBad remove: assBad ]
						ifNotNil: [
							result add: (EchoDivergenceAssign
								reference: reconvBad
								modified: assBad
								flow: true
								state: false).
							solveGood remove: reconvBad.
							solveBad remove: assBad.
							shift := shift max:
								         reconvBad programCounter - assBad programCounter ].
					self
						divergenceAssignementGood: solveGood
						bad: solveBad
						result: result
						shift: shift ] ] ].
	^ result
]

{ #category : 'as yet unclassified' }
Echo >> divergenceConvergenceGood: solveGood bad: solveBad result: result [

	| size assGood assBad shift r1 reconvGood reconvBad collectGood collectBad  |
	1halt.
	size := solveGood size max: solveBad size.
	1 to: size do: [ :a |
		assGood := solveGood at: a ifAbsent: [ 1halt. DASTGoodMissing new ].
		assBad := solveBad at: a ifAbsent: [ 1halt. DASTBadMissing new ].
		(assGood programCounter + shift = assBad programCounter and: [
			 assGood node isEquivalentTo: assBad node ]) ifFalse: [
			r1 := EchoDivergenceMessage reference: assGood modified: assBad.
			
			shift := assGood programCounter - assBad programCounter.
			reconvGood := solveGood select: [ :d |
				              (d node isEquivalentTo: assBad node) and: [
					              d programCounter - shift > assBad programCounter ] ].
			reconvBad := solveBad select: [ :d |
				             (d node isEquivalentTo: assGood node) and: [
					             d programCounter - shift > assGood programCounter ] ].
			reconvGood ifNotEmpty: [
				collectGood := solveGood select: [ :d |
					               d programCounter >= assGood programCounter and: [
						               d programCounter
						               < reconvGood first programCounter ] ].
				collectGood do: [ :d | solveGood remove: d ] .1halt.].
			reconvBad ifNotEmpty: [
				collectBad := solveBad select: [ :d |
					              d programCounter >= assBad programCounter and: [
						              d programCounter < reconvGood first programCounter ] ].
				collectBad do: [ :d | solveBad remove: d ] ].
			result add: r1 ] .
		size := solveGood size max: solveBad size.].
	^ result.
]

{ #category : 'as yet unclassified' }
Echo >> divergenceConvergenceGood: solveGood bad: solveBad result: result shift: baseShift [

	| size assGood assBad r1 reconvGood reconvBad collectGood collectBad shift |
	size := solveGood size max: solveBad size.

	[ solveGood isNotEmpty and: [ solveBad isNotEmpty ] ] whileTrue: [
		assGood := solveGood at: 1 ifAbsent: [ DASTGoodMissing new ].
		assBad := solveBad at: 1 ifAbsent: [ DASTBadMissing new ].
		(assGood programCounter - baseShift = assBad programCounter and: [
			 assGood node isEquivalentTo: assBad node ]) ifFalse: [shift := assGood programCounter - assBad programCounter.
			r1 := EchoDivergenceMessage
				      reference: assGood
				      modified: assBad
				      shift: shift.
			shift := assGood programCounter - assBad programCounter.
			reconvGood := solveGood select: [ :d |
				              (d node isEquivalentTo: assBad node) and: [
					              d programCounter - shift > assBad programCounter ] ].
			reconvBad := solveBad select: [ :d |
				             (d node isEquivalentTo: assGood node) and: [
					             d programCounter - shift > assGood programCounter ] ].
			reconvGood ifNotEmpty: [
				collectGood := solveGood select: [ :d |
					               d programCounter >= assGood programCounter and: [
						               d programCounter
						               < reconvGood first programCounter ] ].
				collectGood do: [ :d | solveGood remove: d ].
				shift := reconvGood first programCounter - assBad programCounter ].
			reconvBad ifNotEmpty: [
				collectBad := solveBad select: [ :d |
					              d programCounter >= assBad programCounter and: [
						              d programCounter < reconvGood first programCounter ] ].
				collectBad do: [ :d | solveBad remove: d ].
				shift := assGood programCounter - reconvBad first programCounter ].
			r1 collectGood: collectGood .
			r1 collectBad: collectBad .
			result add: r1.
			^ self
				  divergenceConvergenceGood: solveGood
				  bad: solveBad
				  result: result
				  shift: shift ].
		solveBad remove: assBad ifAbsent: [  ].
		solveGood remove: assGood ifAbsent: [  ] ].
	^ result
]

{ #category : 'executing' }
Echo >> execute [


	| programmState result |
	result := OrderedCollection new.
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
	result add: programmState goodProgState .
	result add: programmState badProgState .
	result add: (self analyseDiv: programmState ).
	^ result

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

	| goodState badState ttqGood solveGood ttqBad badSolve r shift |
	goodState := programmState goodProgState.
	badState := programmState badProgState.


	ttqGood := TTQAllMessage queryFrom: goodState.
	solveGood := QSCollection solve: ttqGood.

	ttqBad := TTQAllMessage queryFrom: badState.
	badSolve := QSCollection solve: ttqBad.

	shift := 0.
	r := OrderedCollection new.
	
	^ self divergenceConvergenceGood: solveGood bad: badSolve result: r shift: shift
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
