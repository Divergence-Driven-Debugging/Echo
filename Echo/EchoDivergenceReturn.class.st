Class {
	#name : 'EchoDivergenceReturn',
	#superclass : 'EchoDivergence',
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'printing' }
EchoDivergenceReturn >> printBadReturn: str [

	modified state ifNotNil: [ 
		
		str space.
		str <<  modified  state currentContext messageNode printString .
		str << ': '.
		str <<  modified state returnValue printString .
		]
	
]

{ #category : 'printing' }
EchoDivergenceReturn >> printGoodReturn: str [

	reference state ifNotNil: [ 
		
		str space.
		str <<  reference  state currentContext messageNode printString .
		str << ': '.
		str <<  reference state returnValue printString .
		]
	
]

{ #category : 'printing' }
EchoDivergenceReturn >> printOn: str [

	str << '[Return] '.
	self printGoodReturn: str.
	self printBadReturn: str.
	
]

{ #category : 'accessing' }
EchoDivergenceReturn >> returnBad [

	^ reference
]

{ #category : 'accessing' }
EchoDivergenceReturn >> returnBad: anObject [

	modified := anObject
]

{ #category : 'accessing' }
EchoDivergenceReturn >> returnGood [

	^ reference 
]

{ #category : 'accessing' }
EchoDivergenceReturn >> returnGood: anObject [

	reference := anObject
]
