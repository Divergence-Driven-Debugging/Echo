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
	#category : 'Echo-Model',
	#package : 'Echo',
	#tag : 'Model'
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
EchoDivergenceAssign >> description [

	^ 'Divergence on State : ', reference object name , ' for variable ' ,reference variable name.
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

{ #category : 'testing' }
EchoDivergenceAssign >> isAssignment [ 

	^ true
]

{ #category : 'printing' }
EchoDivergenceAssign >> printBadState: str [ 

str space.
		str << reference variable printString.
		str << ': '.
		str << reference value printString.
		str << ' <--> '.
		str << modified variable printString.
		str << ': '.
		str << modified value printString.
	
]

{ #category : 'printing' }
EchoDivergenceAssign >> printGoodState: str [

	str space.
	str << reference variable printString.
	str << ': '.
	str	<< ', ' << (reference stringFor: [ reference oldValue ] withDefault: 'unknown old-value')  
		<< ', ' << (reference stringFor: [reference newValue ] withDefault: 'unknown new-value')
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
EchoDivergenceAssign >> startPositionModified [

	^ modified position
]

{ #category : 'accessing' }
EchoDivergenceAssign >> startPositionReference [

	^ reference position
]

{ #category : 'accessing' }
EchoDivergenceAssign >> state [

	^ state
]

{ #category : 'accessing' }
EchoDivergenceAssign >> state: anObject [

	state := anObject
]

{ #category : 'accessing' }
EchoDivergenceAssign >> stopPositionModified [

	^ modified position 
]

{ #category : 'accessing' }
EchoDivergenceAssign >> stopPositionReference [ 

	^ reference position
]
