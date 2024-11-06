"
Basic divergence model
"
Class {
	#name : 'EchoDivergence',
	#superclass : 'Object',
	#instVars : [
		'reference',
		'modified'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'instance creation' }
EchoDivergence class >> reference: ref modified: mod [
	^self new reference: ref modified: mod
]

{ #category : 'accessing' }
EchoDivergence >> modified [

	^ modified
]

{ #category : 'accessing' }
EchoDivergence >> modified: anObject [

	modified := anObject
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
