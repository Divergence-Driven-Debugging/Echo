Class {
	#name : 'EchoAnalyse',
	#superclass : 'Object',
	#instVars : [
		'originHistory',
		'modifiedHistory'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
EchoAnalyse >> analyseDiv: recorder [

	| asDiv messageDiv div |

	div := EchoResult new.
	"messageDiv := self messageDiv:recorder ."
	asDiv := self assignementDiv:recorder.
	"creationInstanceDiv := self creationInstanceDiv: programmState."   
	div assignementDivergences addAll: asDiv  .
	div flowDivergences addAll: messageDiv .
	^ div
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> assignementDiv: recorder [

	| originalState modifiedState solveGood ttqBad modifiedSolve r |
	r := OrderedCollection new.

	^ self
		  divergenceAssignementGood: recorder originalTrace
		  modified: recorder modifiedTrace
		  result: r
		  shift: 0
]

{ #category : 'alg' }
EchoAnalyse >> assignementEquivalent: aTraceOrigin modified: aTraceModified divergences: divergences [
	
	| sameState origineObject modifiedObject |
	1halt.
	origineObject:= (originHistory at: (aTraceOrigin object at: 'hash')) recreateAt: aTraceOrigin timestamp.
	modifiedObject:= (modifiedHistory at: (aTraceModified object at: 'hash')) recreateAt: aTraceModified timestamp.
	sameState := (DeepComparator new
										assert: origineObject
										deepEquals: modifiedObject).
	
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
		assO isAssignment ifTrue:[
		(self assignementEquivalent: assO  modified: assM divergences: result).
		cmpO := cmpO + 1.
		cmpM := cmpM + 1.]
		ifFalse: [ self divergenceAssignementGood: assO children modified: assM children result: result shift: baseShift .
			cmpO := cmpO + 1.
		cmpM := cmpM + 1.]
		 ].
	^ result
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> divergenceConvergenceGood: solveGood modified: solveBad result: result [

	| cmpO cmpM result messO messM |
	cmpO := 1.
	cmpM := 1.
	[ solveGood size ~= (cmpO - 1) and: [ solveBad size ~= (cmpO - 1) ] ]
		whileTrue: [
			messO := solveGood at: cmpO.
			messM := solveBad at: cmpM.
			self method: messO isSame: messM divergences: result.
			cmpO := cmpO + 1.
			cmpM := cmpM + 1 ].
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
EchoAnalyse >> method: messO isSame: messM [

	| methodEquivalent argumentsIsSame methodIsSame senderIsSame receiverIsSame |
	methodIsSame := messO node name = messM node name.
	argumentsIsSame := messO arguments = messM arguments.
	senderIsSame := messO sender
		                isEquivalentTo: messM sender
		                timeStampO: messO timestamp
		                timeStampM: messM timestamp.
	receiverIsSame := messO object
		                  isEquivalentTo: messM object
		                  timeStampO: messO timestamp
		                  timeStampM: messM timestamp.

	methodEquivalent := methodIsSame and: [
		                    argumentsIsSame and: [
			                    senderIsSame and: [ receiverIsSame ] ] ].

	^ methodEquivalent
]

{ #category : 'algo' }
EchoAnalyse >> method: messO isSame: messM divergences: aCollection [ 
	
	| methodEquivalent |

	methodEquivalent := self method: messO isSame: messM .

	methodEquivalent ifTrue: [ ^ true ].
	aCollection add: (EchoDivergenceMessage reference: messO modified: messM ).
	^ false
]

{ #category : 'setter' }
EchoAnalyse >> objectHistoryOrigin: origin modified: modified [ 
	
	originHistory := origin .
	modifiedHistory := modified.
]

{ #category : 'algo' }
EchoAnalyse >> reconvergeOnaPoint: aScpMethodTrace onTheOtherVersion: aCollection [

| reconvPoint |
		1halt.
	reconvPoint := aCollection select: [ :e |
		self method: aScpMethodTrace isSame: e ].
	reconvPoint ifEmpty: [ "never reconvergences"  ^nil].

	
]
