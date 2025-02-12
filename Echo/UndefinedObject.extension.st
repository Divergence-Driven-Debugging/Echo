Extension { #name : 'UndefinedObject' }

{ #category : '*Echo' }
UndefinedObject >> modified: assBad result: result solveurOriginal: solveGood solveurModified: solveBad shift: baseShift [

	assBad class = EchoMissingTrace ifTrue: [ ^ baseShift ].
	result add: (EchoDivergenceAssign
			 reference: EchoMissingTrace new
			 modified: assBad
			 flow: true
			 state: true).
	solveBad remove: assBad.
	^ baseShift
]

{ #category : '*Echo' }
UndefinedObject >> position [

	 ^ 0
]

{ #category : '*Echo' }
UndefinedObject >> reference: assGood result: result solveurOriginal: solveGood solveurModified: solveBad shift: baseShift [

	assGood class = EchoMissingTrace ifTrue: [ ^ baseShift ].
	result add: (EchoDivergenceAssign
			 reference: assGood
			 modified: EchoMissingTrace new
			 flow: true
			 state: true).
	solveGood remove: assGood.
	^baseShift 
]
