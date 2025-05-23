Class {
	#name : 'EchoAnalyse',
	#superclass : 'Object',
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
EchoAnalyse >> analyseDiv: recorder [

	| asDiv messageDiv result |

	result := OrderedCollection new.
	messageDiv := self messageDiv:recorder .
	asDiv := self assignementDiv:recorder.
	"creationInstanceDiv := self creationInstanceDiv: programmState."
	result addAll: messageDiv .
	result addAll: asDiv .
	^ result
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> assignementDiv: recorder [

	| originalState modifiedState solveGood ttqBad modifiedSolve r  |

	solveGood := recorder originalTrace  select: [ :t | t isAssignmentTrace ] .

	modifiedSolve := recorder modifiedTrace select: [ :t | t isAssignmentTrace ] .
	
	
	r := OrderedCollection new.
	
	^ self divergenceAssignementGood: solveGood modified: modifiedSolve result: r shift: 0.
	

]

{ #category : 'as yet unclassified' }
EchoAnalyse >> checkAssignementOriginal: assGood modified: assBad [
	"(assGood programCounter - baseShift = assBad programCounter and: [
			 assGood node isEquivalentTo: assBad node ]) "

	^ (assGood variable owningClass name , '_echo'
  = assBad variable owningClass name and: [
	  assGood variable name = assBad variable name ]) and:
	 (EquivalentObject new
		  object: assGood newValue
		  isEquivalent: assBad newValue)
	
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> checkContentMessage: assGood modified: assBad [

	^ (((self
		     checkNameOfClassOriginal: assGood sender
		     modified: assBad sender) and: [
		    self
			    checkNameOfClassOriginal: assGood receiver
			    modified: assBad receiver ]) and: [
		   assGood arguments = assBad arguments ]) and: [
		  assGood selector = assBad selector ]
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> checkDnuOriginal: assGood modified: assBad [


	^ (assGood isDnu xor: [ assBad isDnu ]) not 
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> checkFlowOriginal:assGood modified:assBad shift: aShift [

	^ assGood position - (assBad position) - aShift = 0
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> checkMessageOriginal: assGood modified: assBad [

	^ (self checkDnuOriginal: assGood modified: assBad) and: [self checkContentMessage: assGood modified: assBad]
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> checkMessageOriginal: assGood modified: assBad shift: aShift [

	^ (self checkDnuOriginal: assGood modified: assBad) and:[(self checkContentMessage: assGood modified: assBad) and:[self checkFlowOriginal:assGood modified:assBad shift: aShift ]]
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> checkNameOfClassOriginal: original modified: modified [


	original = modified ifTrue: [ ^ true ].
	^ original name  = (modified name , '_echo') or: [
		  modified name  = (original name  , '_echo') ]
]

{ #category : 'diff' }
EchoAnalyse >> checkSlotValue: originalSlot bad: badSlot [

	| diff result |
	result := OrderedCollection new.
	diff := originalSlot keys select: [ :s |
		        (originalSlot at: s) ~= (badSlot at: s) ].
	diff ifNotEmpty: [
		result := diff reject: [ :s |
			          self
				          checkSlotValue: (originalSlot at: s) slotsValue
				          bad: (badSlot at: s) slotsValue ] ].
	^ result isEmpty
]

{ #category : 'diff' }
EchoAnalyse >> checkSlotValue: originalSlot modified: modifiedSlot [ 
	

	| diff result|
	result := OrderedCollection new.
	diff := originalSlot keys select: [ :s | ((originalSlot at: s ) = (modifiedSlot at: s )) not].
	diff ifNotEmpty: [ result := diff select: [ :s | (self checkSlotValue: ((originalSlot at: s) slotsValue)  modified: ((modifiedSlot at: s) slotsValue) )not] ].
	^ result isEmpty 
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> divergenceAssignementGood: solveGood modified: solveBad result: result shift: baseShift [

	 | assGood assBad reconvGood reconvBad shift |
	 shift := 0.
	 [ solveGood isNotEmpty or: [ solveBad isNotEmpty ] ] whileTrue: [
		 assGood := solveGood at: 1 ifAbsent: [ EchoMissingTrace new ].
		 assBad := solveBad at: 1 ifAbsent: [ EchoMissingTrace new ].
		 (self checkAssignementOriginal: assGood modified: assBad)
			 ifTrue: [
				 solveGood remove: assGood.
				 solveBad remove: assBad.
				 assGood id: 1.
				 assBad id: 1 ]
			 ifFalse: [
				 assGood id: assGood hash.
				 assBad id: assBad hash.
				 reconvGood := (solveBad select: [ :ps |
					                self
						                checkAssignementOriginal: assGood
						                modified: ps ]) at: 1 ifAbsent: [ nil ].
				 reconvBad := (solveGood select: [ :ps |
					               self checkAssignementOriginal: ps modified: assBad ])
					              at: 1
					              ifAbsent: [ nil ].
				 shift := reconvGood
					          reference: assGood
					          result: result
					          solveurOriginal: solveGood
					          solveurModified: solveBad
					          shift: baseShift.
				 shift := reconvBad
					          modified: assBad
					          result: result
					          solveurOriginal: solveGood
					          solveurModified: solveBad
					          shift: baseShift ] ].
	 ^ result
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> divergenceConvergenceGood: solveGood modified: solveBad result: result shift: baseShift originalReturn: originalReturn modifiedReturn: modifiedReturn [

	 | size assGood assBad r1 reconvGood reconvBad collectGood collectBad shift |
	 size := solveGood size max: solveBad size.

	 [ solveGood isNotEmpty or: [ solveBad isNotEmpty ] ] whileTrue: [
		 assGood := solveGood at: 1 ifAbsent: [ EchoMissingTrace new ].
		 assBad := solveBad at: 1 ifAbsent: [ EchoMissingTrace new ].
		 (self
			  checkMessageOriginal: assGood
			  modified: assBad
			  shift: baseShift)
			 ifTrue: [
				 assGood id: 1.
				 assBad id: 1 ]
			 ifFalse: [
				 assGood id: assGood hash.
				 assBad id: assBad hash.

				 r1 := EchoDivergenceMessage
					       reference: assGood
					       modified: assBad
					       shift: shift.
				 reconvGood := solveGood select: [ :d |
					               (self checkMessageOriginal: d modified: assBad) ifTrue: [ 1halt. true ] ifFalse: false ].

				 reconvGood ifNotEmpty: [
					 reconvGood do: [ :d | solveGood remove: d ] ].

				 reconvBad := solveBad select: [ :d |
					             ( self checkMessageOriginal: assGood modified: d) ifTrue: [ 1halt. true ] ifFalse: false ].
				 reconvBad ifNotEmpty: [
					 reconvBad do: [ :d | solveBad remove: d ] ].


				 r1 collectGood: reconvGood.
				 r1 collectBad: reconvBad.
				 result add: r1.
				 (reconvGood isEmpty and: reconvBad isEmpty) ifTrue: [
					 solveBad remove: assBad ifAbsent: [  ].
					 solveGood remove: assGood ifAbsent: [  ] ].
				 shift := baseShift + reconvGood firstOrNil position
				          - assBad position.
				 solveBad remove: assBad ifAbsent: [  ].
				 solveGood remove: assGood ifAbsent: [  ].
				 ^ self
					   divergenceConvergenceGood: solveGood
					   modified: solveBad
					   result: result
					   shift: shift
					   originalReturn: originalReturn
					   modifiedReturn: modifiedReturn ].
		 solveBad remove: assBad ifAbsent: [  ].
		 solveGood remove: assGood ifAbsent: [  ] ].
	 ^ result
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> messageDiv: recorder [

	| originalState modifiedState ttqGood solveGood ttqBad modifiedSolve r shift ttqGoodReturn solveGoodReturn ttqBadReturn solveBadReturn |
	
	solveGood := recorder originalTrace  select: [ :t | t isMessageTrace ] .

	modifiedSolve := recorder modifiedTrace select: [ :t | t isMessageTrace ].
	
	"ttqGoodReturn := TTQAllReturn queryFrom: originalState.
	solveGoodReturn := QSCollection solve: ttqGoodReturn.

	ttqBadReturn := TTQAllReturn queryFrom: modifiedState.
	solveBadReturn := QSCollection solve: ttqBadReturn."

	shift := 0.
	r := OrderedCollection new.
	
	self divergenceConvergenceGood: solveGood modified: modifiedSolve result: r shift: shift originalReturn: solveGoodReturn modifiedReturn: solveBadReturn .
		"r addAll:(self  returnDivGood: solveGoodReturn modified: solveBadReturn) ".
	^r 
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> returnGood: aGoodValue  equivalentBad: aBadValue [


	aGoodValue = aBadValue ifFalse: [ 
		^  (aGoodValue class name , '_echo') = (aBadValue class name ) ].
	^ true.
		
		 

]
