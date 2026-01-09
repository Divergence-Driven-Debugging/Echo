Class {
	#name : 'EchoAnalyse',
	#superclass : 'Object',
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
EchoAnalyse >> analyseDiv: recorder [

	| asDiv messageDiv div |

	div := EchoResult new.
	messageDiv := self messageDiv:recorder .
	asDiv := self assignementDiv:recorder.
	"creationInstanceDiv := self creationInstanceDiv: programmState."   
	div assignementDivergences addAll: asDiv  .
	div flowDivergences addAll: messageDiv .
	^ div
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> assignementDiv: recorder [

	| originalState modifiedState solveGood ttqBad modifiedSolve r  |

	solveGood := recorder originalTrace  select: [ :t | t isAssignment] .

	modifiedSolve := recorder modifiedTrace select: [ :t | t isAssignment ] .
	
	
	r := OrderedCollection new.
	
	^ self divergenceAssignementGood: solveGood modified: modifiedSolve result: r shift: 0.
	

]

{ #category : 'alg' }
EchoAnalyse >> assignementEquivalent: aTraceOrigin modified: aTraceModified divergences: divergences [
	
	| sameState |
	sameState := (DeepComparator new
										assert: aTraceOrigin object
										deepEquals: aTraceModified object).
	
	sameState  ifTrue: [ ^nil ].
	divergences add: (EchoDivergenceAssign  reference: aTraceOrigin 
									 modified: aTraceModified 
									flow: false 
									state: sameState )
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> divergenceAssignementGood: solveGood modified: solveBad result: result shift: baseShift [

	| cmpO cmpM assM assO result|
	cmpO := 1.
	cmpM := 1.
	result := OrderedCollection new.
	[solveGood size ~=  (cmpO - 1) and: [ solveBad size ~= (cmpO-1) ]] whileTrue: [ 
		assO := solveGood at: cmpO .
		assM := solveBad at: cmpM.
		(self assignementEquivalent: assO  modified: assM divergences: result).
		cmpO := cmpO + 1.
		cmpM := cmpM + 1.
		 ].
	^ result
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> divergenceConvergenceGood: solveGood modified: solveBad result: result [ 
	| cmpO cmpM result messO messM |
	cmpO := 1.
	cmpM := 1.
	[solveGood size ~=  (cmpO - 1) and: [ solveBad size ~= (cmpO-1) ]] whileTrue: [ 
		messO := solveGood at: cmpO .
		messM := solveBad at: cmpM.
		self method:messO isSame: messM divergences: result.
		cmpO := cmpO + 1.
		cmpM := cmpM + 1.
		 ].
	^ result
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> messageDiv: recorder [

	|    solveGood  modifiedSolve r shift  solveGoodReturn  solveBadReturn |
	
	solveGood := recorder originalTrace  select: [ :t | t isMethod ] .

	modifiedSolve := recorder modifiedTrace select: [ :t | t isMethod ].
	


	shift := 0.
	r := OrderedCollection new.

	self divergenceConvergenceGood: solveGood modified: modifiedSolve result: r .
	^r 
]

{ #category : 'algo' }
EchoAnalyse >> method: messO isSame: messM divergences: aCollection [ 
	
	| methodEquivalent |
	
	methodEquivalent := (messO = messM).

	methodEquivalent ifTrue: [ ^ nil ].
	aCollection add: (EchoDivergenceMessage reference: messO modified: messM )
]
