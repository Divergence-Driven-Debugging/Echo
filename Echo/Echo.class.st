Class {
	#name : 'Echo',
	#superclass : 'Object',
	#instVars : [
		'good',
		'bad',
		'interpreterGood',
		'interpreterBad',
		'packages',
		'algo'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'accessing' }
Echo >> bad [

	^ bad
]

{ #category : 'accessing' }
Echo >> bad: anObject [

	bad := anObject
]

{ #category : 'executing' }
Echo >> execute [


	
	interpreterGood := DASTInterpreter new.
	interpreterGood initializeWithProgram: ((RBParser parseExpression: good)).
	interpreterBad := DASTInterpreter new.
	interpreterBad initializeWithProgram: ((RBParser parseExpression: bad)).
	algo good: interpreterGood bad: interpreterBad .
	[ interpreterGood isTerminated not] whileTrue: [ 
	algo algoDiff.
	self step]

]

{ #category : 'accessing' }
Echo >> good [

	^ good
]

{ #category : 'accessing' }
Echo >> good: anObject [

	good := anObject
]

{ #category : 'initialization' }
Echo >> initialize [ 

	algo := EchoAlgo new.
]

{ #category : 'accessing' }
Echo >> packages [
	
	^ packages
]

{ #category : 'accessing' }
Echo >> packages: anObject [

	packages := anObject
]

{ #category : 'executing' }
Echo >> step [

	((self packages includes: interpreterGood receiver package) or: [
		 interpreterGood receiver = nil ])
		ifTrue: [
			interpreterGood stepInto.
			interpreterBad stepInto ]
		ifFalse: [
			interpreterGood stepOver.
			interpreterBad stepOver ]
]
