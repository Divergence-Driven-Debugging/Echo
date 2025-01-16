Class {
	#name : 'EchoAnalyse',
	#superclass : 'Object',
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
EchoAnalyse >> analyseDiv: programmState [

	| asDiv messageDiv result |

	result := OrderedCollection new.
	asDiv := self assignementDiv: programmState.
	messageDiv := self messageDiv: programmState.
	"creationInstanceDiv := self creationInstanceDiv: programmState."
	result addAll: messageDiv .
	result addAll: asDiv .
	^ result
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> assignementDiv: programmState [

	| originalState modifiedState ttqGood solveGood ttqBad modifiedSolve r |
	originalState := programmState originalProgState.
	modifiedState := programmState modifiedProgState.


	ttqGood := TTQAllAssignments queryFrom: originalState.
	solveGood := QSCollection solve: ttqGood.

	ttqBad := TTQAllAssignments queryFrom: modifiedState.
	modifiedSolve := QSCollection solve: ttqBad.

	r := OrderedCollection new.
	
	^ self divergenceAssignementGood: solveGood modified: modifiedSolve result: r shift: 0.
	

]

{ #category : 'diff' }
EchoAnalyse >> checkSlotValue: originalSlot bad: badSlot [ 
	

	| diff result|
	result := OrderedCollection new.
	diff := originalSlot keys select: [ :s | ((originalSlot at: s ) = (badSlot at: s )) not].
	diff ifNotEmpty: [ result := diff select: [ :s | (self checkSlotValue: ((originalSlot at: s) slotsValue)  bad: ((badSlot at: s) slotsValue) )not] ].
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
EchoAnalyse >> creationInstanceDiv: programmState [

	| originalState modifiedState ttqGood solveGood ttqBad modifiedSolve r assGood assBad r1 size |
	originalState := programmState originalProgState.
	modifiedState := programmState modifiedProgState.

	
	ttqGood := TTQAllInstanceCreations queryFrom: originalState.
	solveGood := QSCollection solve: ttqGood.

	ttqBad := TTQAllInstanceCreations queryFrom: modifiedState.
	modifiedSolve := QSCollection solve: ttqBad.

	r := OrderedCollection new.
	size :=  (solveGood size) max:( modifiedSolve size). 
	1 to: size do: [ :a |
		assGood := solveGood at: a ifAbsent: [DASTGoodMissing new].
		assBad := modifiedSolve at: a ifAbsent: [DASTBadMissing new].
		r1 := OrderedCollection new.
		r1 add: assGood.
		r1 add: assBad.
		r1 add: assGood programCounter = assBad programCounter.
		r1 add: (assGood node isEquivalentTo: assBad node).
		r add: r1 ].
	^ r
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> divergenceAssignementGood: solveGood bad: solveBad result: result shift: baseShift [

	| assGood assBad reconvGood reconvBad shift |
	
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
						ifNil: [(assGood class = DASTBadMissing )ifFalse: [ 
							result add:  (EchoDivergenceAssign
								reference: assGood 
								modified:  DASTBadMissing new 
								flow: true
								state: true) .
								solveGood remove: assGood ]]
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
						ifNil: [(assBad class = DASTBadMissing )ifFalse: [ 
							result add: (EchoDivergenceAssign
								reference: DASTGoodMissing new
								modified:  assBad 
								flow: true
								state: true ).
								solveBad remove: assBad ]]
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
EchoAnalyse >> divergenceAssignementGood: solveGood modified: solveBad result: result shift: baseShift [

	| assGood assBad reconvGood reconvBad shift |
	
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
						modified: solveBad
						result: result
						shift: assGood programCounter - assBad programCounter ]
				ifFalse: [
					reconvGood := (solveBad select:
						              [ :ps | ps node isEquivalentTo: assGood node ])
							              at: 1 ifAbsent: [ nil ] .
					reconvBad := (solveGood select:
						             [ :ps | ps node isEquivalentTo: assBad node ] )at: 1 ifAbsent: [ nil ].
					reconvGood
						ifNil: [(assGood class = DASTBadMissing )ifFalse: [ 
							result add:  (EchoDivergenceAssign
								reference: assGood 
								modified:  DASTBadMissing new 
								flow: true
								state: true) .
								solveGood remove: assGood ]]
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
						ifNil: [(assBad class = DASTBadMissing )ifFalse: [ 
							result add: (EchoDivergenceAssign
								reference: DASTGoodMissing new
								modified:  assBad 
								flow: true
								state: true ).
								solveBad remove: assBad ]]
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
						modified: solveBad
						result: result
						shift: shift ] ] ].
	^ result
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> divergenceConvergenceGood: solveGood bad: solveBad result: result shift: baseShift goodReturn: goodReturn badReturn: badReturn [

	| size assGood assBad r1 reconvGood reconvBad collectGood collectBad shift |
	size := solveGood size max: solveBad size.
	
	[ solveGood isNotEmpty and: [ solveBad isNotEmpty ] ] whileTrue: [
		assGood := solveGood at: 1 ifAbsent: [ DASTGoodMissing new ].
		assBad := solveBad at: 1 ifAbsent: [ DASTBadMissing new ].
		(assGood programCounter - baseShift = assBad programCounter and: [
			 (assGood node isEquivalentTo: assBad node) and: [
				 assGood state dnu = assBad state dnu ] ]) ifFalse: [
			shift := assGood programCounter - assBad programCounter.
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
				self removeReturn: goodReturn divergence: collectGood.
				shift := reconvGood first programCounter - assBad programCounter ].
			reconvBad ifNotEmpty: [
				collectBad := solveBad select: [ :d |
					              d programCounter >= assBad programCounter and: [
						              d programCounter < reconvGood first programCounter ] ].
				collectBad do: [ :d | solveBad remove: d ].
				self removeReturn: badReturn divergence: collectBad.
				shift := assGood programCounter - reconvBad first programCounter ].
			r1 collectGood: collectGood.
			r1 collectBad: collectBad.
			result add: r1.
			(reconvGood isEmpty and: reconvBad isEmpty) ifTrue: [
				solveBad remove: assBad ifAbsent: [  ].
				solveGood remove: assGood ifAbsent: [  ] ].

			^ self
				  divergenceConvergenceGood: solveGood
				  bad: solveBad
				  result: result
				  shift: shift
				  goodReturn: goodReturn
				  badReturn: badReturn ].
		solveBad remove: assBad ifAbsent: [  ].
		solveGood remove: assGood ifAbsent: [  ] ].
	^ result
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> divergenceConvergenceGood: solveGood bad: solveBad result: result shift: baseShift originalReturn: originalReturn badReturn: badReturn [

	| size assGood assBad r1 reconvGood reconvBad collectGood collectBad shift |
	size := solveGood size max: solveBad size.
	
	[ solveGood isNotEmpty and: [ solveBad isNotEmpty ] ] whileTrue: [
		assGood := solveGood at: 1 ifAbsent: [ DASTGoodMissing new ].
		assBad := solveBad at: 1 ifAbsent: [ DASTBadMissing new ].
		(assGood programCounter - baseShift = assBad programCounter and: [
			 (assGood node isEquivalentTo: assBad node) and: [
				 assGood state dnu = assBad state dnu ] ]) ifFalse: [
			shift := assGood programCounter - assBad programCounter.
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
				self removeReturn: originalReturn divergence: collectGood.
				shift := reconvGood first programCounter - assBad programCounter ].
			reconvBad ifNotEmpty: [
				collectBad := solveBad select: [ :d |
					              d programCounter >= assBad programCounter and: [
						              d programCounter < reconvGood first programCounter ] ].
				collectBad do: [ :d | solveBad remove: d ].
				self removeReturn: badReturn divergence: collectBad.
				shift := assGood programCounter - reconvBad first programCounter ].
			r1 collectGood: collectGood.
			r1 collectBad: collectBad.
			result add: r1.
			(reconvGood isEmpty and: reconvBad isEmpty) ifTrue: [
				solveBad remove: assBad ifAbsent: [  ].
				solveGood remove: assGood ifAbsent: [  ] ].

			^ self
				  divergenceConvergenceGood: solveGood
				  bad: solveBad
				  result: result
				  shift: shift
				  originalReturn: originalReturn
				  badReturn: badReturn ].
		solveBad remove: assBad ifAbsent: [  ].
		solveGood remove: assGood ifAbsent: [  ] ].
	^ result
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> divergenceConvergenceGood: solveGood modified: solveBad result: result shift: baseShift goodReturn: goodReturn modifiedReturn: modifiedReturn [

	| size assGood assBad r1 reconvGood reconvBad collectGood collectBad shift |
	size := solveGood size max: solveBad size.
	
	[ solveGood isNotEmpty and: [ solveBad isNotEmpty ] ] whileTrue: [
		assGood := solveGood at: 1 ifAbsent: [ DASTGoodMissing new ].
		assBad := solveBad at: 1 ifAbsent: [ DASTBadMissing new ].
		(assGood programCounter - baseShift = assBad programCounter and: [
			 (assGood node isEquivalentTo: assBad node) and: [
				 assGood state dnu = assBad state dnu ] ]) ifFalse: [
			shift := assGood programCounter - assBad programCounter.
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
				self removeReturn: goodReturn divergence: collectGood.
				shift := reconvGood first programCounter - assBad programCounter ].
			reconvBad ifNotEmpty: [
				collectBad := solveBad select: [ :d |
					              d programCounter >= assBad programCounter and: [
						              d programCounter < reconvGood first programCounter ] ].
				collectBad do: [ :d | solveBad remove: d ].
				self removeReturn: modifiedReturn divergence: collectBad.
				shift := assGood programCounter - reconvBad first programCounter ].
			r1 collectGood: collectGood.
			r1 collectBad: collectBad.
			result add: r1.
			(reconvGood isEmpty and: reconvBad isEmpty) ifTrue: [
				solveBad remove: assBad ifAbsent: [  ].
				solveGood remove: assGood ifAbsent: [  ] ].

			^ self
				  divergenceConvergenceGood: solveGood
				  modified: solveBad
				  result: result
				  shift: shift
				  goodReturn: goodReturn
				  modifiedReturn: modifiedReturn ].
		solveBad remove: assBad ifAbsent: [  ].
		solveGood remove: assGood ifAbsent: [  ] ].
	^ result
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> divergenceConvergenceGood: solveGood modified: solveBad result: result shift: baseShift originalReturn: originalReturn modifiedReturn: modifiedReturn [

	| size assGood assBad r1 reconvGood reconvBad collectGood collectBad shift |
	size := solveGood size max: solveBad size.
	
	[ solveGood isNotEmpty and: [ solveBad isNotEmpty ] ] whileTrue: [
		assGood := solveGood at: 1 ifAbsent: [ DASTGoodMissing new ].
		assBad := solveBad at: 1 ifAbsent: [ DASTBadMissing new ].
		(assGood programCounter - baseShift = assBad programCounter and: [
			 (assGood node isEquivalentTo: assBad node) and: [
				 assGood state dnu = assBad state dnu ] ]) ifFalse: [
			shift := assGood programCounter - assBad programCounter.
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
				self removeReturn: originalReturn divergence: collectGood.
				shift := reconvGood first programCounter - assBad programCounter ].
			reconvBad ifNotEmpty: [
				collectBad := solveBad select: [ :d |
					              d programCounter >= assBad programCounter and: [
						              d programCounter < reconvGood first programCounter ] ].
				collectBad do: [ :d | solveBad remove: d ].
				self removeReturn: modifiedReturn divergence: collectBad.
				shift := assGood programCounter - reconvBad first programCounter ].
			r1 collectGood: collectGood.
			r1 collectBad: collectBad.
			result add: r1.
			(reconvGood isEmpty and: reconvBad isEmpty) ifTrue: [
				solveBad remove: assBad ifAbsent: [  ].
				solveGood remove: assGood ifAbsent: [  ] ].

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
EchoAnalyse >> messageDiv: programmState [

	| originalState modifiedState ttqGood solveGood ttqBad modifiedSolve r shift ttqGoodReturn solveGoodReturn ttqBadReturn solveBadReturn |
	originalState := programmState originalProgState.
	modifiedState := programmState modifiedProgState.


	ttqGood := TTQAllMessage queryFrom: originalState.
	solveGood := QSCollection solve: ttqGood.

	ttqBad := TTQAllMessage queryFrom: modifiedState.
	modifiedSolve := QSCollection solve: ttqBad.
	
	ttqGoodReturn := TTQAllReturn queryFrom: originalState.
	solveGoodReturn := QSCollection solve: ttqGoodReturn.

	ttqBadReturn := TTQAllReturn queryFrom: modifiedState.
	solveBadReturn := QSCollection solve: ttqBadReturn.

	shift := 0.
	r := OrderedCollection new.
	
	self divergenceConvergenceGood: solveGood modified: modifiedSolve result: r shift: shift originalReturn: solveGoodReturn modifiedReturn: solveBadReturn .
		r addAll:(self  returnDivGood: solveGoodReturn modified: solveBadReturn) .
	^r 
]

{ #category : 'removing' }
EchoAnalyse >> removeReturn: return divergence: diverge [

	| result |
	result := OrderedCollection new.
	diverge do: [ :d |
		return
			select: [ :r |
				(r state currentContext messageNode ifNil: [ DASTNilNode new ])
					isEquivalentTo: d node ]
			thenDo: [ :r | result add: r ] ].
	result removeDuplicates.
	result do: [ :r | return remove: r ]
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> returnDivGood: originalReturn bad: badReturn [

	| returnGood returnBad result checkReturnGood checkReturnBad |
	
	result := OrderedCollection new.
	[ originalReturn isNotEmpty or: [ originalReturn isNotEmpty ] ] whileTrue: [
		returnGood := originalReturn at: 1 ifAbsent: [ DASTGoodMissing new ].
		returnBad := badReturn at: 1 ifAbsent: [ DASTBadMissing new ].
		((returnGood node isEquivalentTo: returnBad node) and: [
			 self
				 returnGood: returnGood state returnValue
				 equivalentBad: returnBad state returnValue ])
			ifTrue: [
				originalReturn remove: returnGood ifAbsent: [  ].
				badReturn remove: returnBad ifAbsent: [  ] ]
			ifFalse: [
				(returnGood node isEquivalentTo: returnBad node)
					ifTrue: [
						result add: (EchoDivergenceReturn new
								 returnGood: returnGood;
								 returnBad: returnBad;
								 yourself).
						originalReturn remove: returnGood ifAbsent: [  ].
						badReturn remove: returnBad ifAbsent: [  ] ]
					ifFalse: [
						1 halt.
						checkReturnGood := badReturn select: [ :b |
							                   b node isEquivalentTo: returnGood node ].
						checkReturnBad := originalReturn select: [ :b |
							                  b node isEquivalentTo: returnBad node ].
						checkReturnGood ifEmpty: [
							result add: (EchoDivergenceReturn new
									 returnGood: returnGood;
									 yourself).
							originalReturn remove: returnGood ifAbsent: [  ] ].
						checkReturnBad ifEmpty: [
							result add: (EchoDivergenceReturn new
									 returnBad: returnBad;
									 yourself).
							badReturn remove: returnBad ifAbsent: [  ] ] ] ] ].
			
		^ result 
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> returnDivGood: originalReturn modified: modifiedReturn [

	| returnGood returnBad result checkReturnGood checkReturnBad |
	
	result := OrderedCollection new.
	[ originalReturn isNotEmpty or: [ originalReturn isNotEmpty ] ] whileTrue: [
		returnGood := originalReturn at: 1 ifAbsent: [ DASTGoodMissing new ].
		returnBad := modifiedReturn at: 1 ifAbsent: [ DASTBadMissing new ].
		((returnGood node isEquivalentTo: returnBad node) and: [
			 self
				 returnGood: returnGood state returnValue
				 equivalentBad: returnBad state returnValue ])
			ifTrue: [
				originalReturn remove: returnGood ifAbsent: [  ].
				modifiedReturn remove: returnBad ifAbsent: [  ] ]
			ifFalse: [
				(returnGood node isEquivalentTo: returnBad node)
					ifTrue: [
						result add: (EchoDivergenceReturn new
								 returnGood: returnGood;
								 returnBad: returnBad;
								 yourself).
						originalReturn remove: returnGood ifAbsent: [  ].
						modifiedReturn remove: returnBad ifAbsent: [  ] ]
					ifFalse: [
						1 halt.
						checkReturnGood := modifiedReturn select: [ :b |
							                   b node isEquivalentTo: returnGood node ].
						checkReturnBad := originalReturn select: [ :b |
							                  b node isEquivalentTo: returnBad node ].
						checkReturnGood ifEmpty: [
							result add: (EchoDivergenceReturn new
									 returnGood: returnGood;
									 yourself).
							originalReturn remove: returnGood ifAbsent: [  ] ].
						checkReturnBad ifEmpty: [
							result add: (EchoDivergenceReturn new
									 returnBad: returnBad;
									 yourself).
							modifiedReturn remove: returnBad ifAbsent: [  ] ] ] ] ].
			
		^ result 
]

{ #category : 'as yet unclassified' }
EchoAnalyse >> returnGood: aGoodValue  equivalentBad: aBadValue [


	aGoodValue = aBadValue ifFalse: [ 
		^  (aGoodValue class name , '_echo') = (aBadValue class name ) ].
	^ true.
		
		 

]
