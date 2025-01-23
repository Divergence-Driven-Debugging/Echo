Extension { #name : 'UndefinedObject' }

{ #category : '*Echo' }
UndefinedObject >> modified: assBad result: result solveurOriginal: solveGood solveurModified: solveBad shift: baseShift [

	assBad class = DASTBadMissing ifTrue: [ ^ baseShift ].
	result add: (EchoDivergenceAssign
			 reference: DASTGoodMissing new
			 modified: assBad
			 flow: true
			 state: true).
	solveBad remove: assBad.
	^ baseShift
]

{ #category : '*Echo' }
UndefinedObject >> reference: assGood result: result solveurOriginal: solveGood solveurModified: solveBad shift: baseShift [

	assGood class = DASTBadMissing ifTrue: [ ^ baseShift ].
	result add: (EchoDivergenceAssign
			 reference: assGood
			 modified: DASTBadMissing new
			 flow: true
			 state: true).
	solveGood remove: assGood.
	^baseShift 
]
