Extension { #name : 'ScpAssignmentTrace' }

{ #category : '*Echo' }
ScpAssignmentTrace >> modified: assBad result: result solveurOriginal: solveGood solveurModified: solveBad shift: baseShift [

result add: (EchoDivergenceAssign
								reference: self
								modified: assBad
								flow: true
								state: false).
							solveGood remove: self.
							solveBad remove: assBad.

]

{ #category : '*Echo' }
ScpAssignmentTrace >> reference: assGood result: result solveurOriginal: solveGood solveurModified: solveBad shift: baseShift [

	result add: (EchoDivergenceAssign
			 reference: assGood
			 modified: self
			 flow: true
			 state: false).
	solveGood remove: assGood.
	solveBad remove: self.
	
]
