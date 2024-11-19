"
""flow correspond a si la divergence est lie au flow ou non, si oui la variable est a true
state correspond a si la divergence est lie au state ou non, si oui la variable est a true""
"
Class {
	#name : 'EchoDivergenceAssign',
	#superclass : 'EchoDivergence',
	#instVars : [
		'flow',
		'state'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
EchoDivergenceAssign class >> reference: ref modified: mod flow: flow state: state [

	^ self new
		  reference: ref;
		  modified: mod;
		  flow: flow;
		  state: state;
		  yourself
]

{ #category : 'accessing' }
EchoDivergenceAssign >> flow [

	^ flow
]

{ #category : 'accessing' }
EchoDivergenceAssign >> flow: anObject [

	flow := anObject
]

{ #category : 'accessing' }
EchoDivergenceAssign >> icon [
	^Smalltalk ui iconNamed: #instVarsSelected
]

{ #category : 'printing' }
EchoDivergenceAssign >> printBadState: str [ 

str space.
		str << reference node variable printString.
		str << ': '.
		str << reference node value printString.
		str << ' <--> '.
		str << modified node variable printString.
		str << ': '.
		str << modified node value printString.
	
]

{ #category : 'printing' }
EchoDivergenceAssign >> printGoodState: str [

	str space.
	str << reference node variable printString.
	str << ': '.
	str << ' Good State '.
	str << ' Bad Flow'
]

{ #category : 'printing' }
EchoDivergenceAssign >> printOn: str [

	str << '[Assignment] '.
	self state  ifTrue: [ self printBadState: str  ]  ifFalse:  [ self printGoodState: str ] 
	
]

{ #category : 'api - selection' }
EchoDivergenceAssign >> selectItem:modifiedStack [

^ (modifiedStack items select: [:s | s programCounter = ((self modified programCounter)  - (self shift)) ]) first
]

{ #category : 'accessing' }
EchoDivergenceAssign >> state [

	^ state
]

{ #category : 'accessing' }
EchoDivergenceAssign >> state: anObject [

	state := anObject
]
