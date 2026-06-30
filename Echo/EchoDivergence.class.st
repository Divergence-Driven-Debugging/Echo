"
Basic divergence model

modified is the program state in the bad version
reference is the state in the original version

"
Class {
	#name : 'EchoDivergence',
	#superclass : 'Object',
	#instVars : [
		'reference',
		'modified',
		'shift',
		'isLinkedToOtherDiv',
		'linkedDivergence'
	],
	#category : 'Echo-Model',
	#package : 'Echo',
	#tag : 'Model'
}

{ #category : 'instance creation' }
EchoDivergence class >> reference: ref modified: mod [
	^self new reference: ref modified: mod
]

{ #category : 'instance creation' }
EchoDivergence class >> reference: ref modified: mod shift: shift [

	^ self new
		  reference: ref;
		  modified: mod;
		  shift: shift;
		  yourself
]

{ #category : 'accessing' }
EchoDivergence >> description [ 
	

	self shouldBeImplemented 
]

{ #category : 'accessing' }
EchoDivergence >> icon [

	 self shouldBeImplemented
]

{ #category : 'initialization' }
EchoDivergence >> initialize [ 

	isLinkedToOtherDiv := false.
	linkedDivergence := OrderedCollection new
]

{ #category : 'testing' }
EchoDivergence >> isAssignment [

	 ^ false
]

{ #category : 'accessing' }
EchoDivergence >> isLinkedToOtherDiv [

	^ isLinkedToOtherDiv
]

{ #category : 'accessing' }
EchoDivergence >> isLinkedToOtherDiv: anObject [

	isLinkedToOtherDiv := anObject
]

{ #category : 'testing' }
EchoDivergence >> isMessage [ 

	 ^ false
]

{ #category : 'accessing' }
EchoDivergence >> linkedDivergence [

	^ linkedDivergence
]

{ #category : 'accessing' }
EchoDivergence >> linkedDivergence: anObject [

	linkedDivergence := anObject
]

{ #category : 'accessing' }
EchoDivergence >> modified [

	^ modified
]

{ #category : 'accessing' }
EchoDivergence >> modified: anObject [

	modified := anObject
]

{ #category : 'printing' }
EchoDivergence >> printOn: str [

	reference node isMessage ifTrue: [
		str << '[Message] '.
		str space.
		str << reference node selector.
		str << ' <-> '.
		str << modified node selector.
		^ self ].



	str << '[Assignment] '.
	str space.
		str << reference node variable printString.
		str << ': '.
		str << reference node value printString.
		str << ' <-> '.
		str << modified node variable printString.
		str << ': '.
		str << modified node value printString.
]

{ #category : 'accessing' }
EchoDivergence >> reference [

	^ reference
]

{ #category : 'accessing' }
EchoDivergence >> reference: anObject [

	reference := anObject
]

{ #category : 'initialize' }
EchoDivergence >> reference: ref modified: mod [
	reference := ref.
	modified := mod
]

{ #category : 'accessing' }
EchoDivergence >> shift [

	^ shift
]

{ #category : 'accessing' }
EchoDivergence >> shift: anObject [

	shift := anObject .
	shift ifNil: [ shift := 0 ]
	
]

{ #category : 'accessing' }
EchoDivergence >> startPositionModified [ 

	self shouldBeImplemented 
]

{ #category : 'accessing' }
EchoDivergence >> startPositionReference [ 

	self shouldBeImplemented 
]

{ #category : 'accessing' }
EchoDivergence >> stopPositionModified [ 

	self shouldBeImplemented 
]

{ #category : 'accessing' }
EchoDivergence >> stopPositionReference [

	self shouldBeImplemented 
]
