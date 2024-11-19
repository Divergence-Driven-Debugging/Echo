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
		'shift'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
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
EchoDivergence >> icon [
	^self subclassResponsibility 
]

{ #category : 'initialization' }
EchoDivergence >> initialize [ 

	reference := DASTGoodMissing new.
	modified := DASTBadMissing  new.
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
