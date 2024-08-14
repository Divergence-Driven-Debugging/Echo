Extension { #name : 'RBProgramNode' }

{ #category : '*Echo' }
RBProgramNode >> isEquivalentTo: aNode [
	self flag: 'should be tested, does not work on methods after links because of the wrappping now in place'.
	^ aNode methodNode selector = self methodNode selector
		and: [ aNode = self]
]
