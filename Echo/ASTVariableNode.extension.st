Extension { #name : 'ASTVariableNode' }

{ #category : '*Echo' }
ASTVariableNode >> = anObject [
	self == anObject ifTrue: [^true].
	((anObject isKindOf: self class) or: [self isKindOf: anObject class])
		ifFalse: [^false].
	^(self name = anObject name or: [self name = (anObject name , '_echo')] ) or: [anObject name = (self name , '_echo')]
]
