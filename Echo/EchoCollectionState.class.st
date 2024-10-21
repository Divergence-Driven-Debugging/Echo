Class {
	#name : 'EchoCollectionState',
	#superclass : 'Object',
	#instVars : [
		'badInterpret',
		'goodInterpret',
		'goodProgState',
		'badProgState'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'accessing' }
EchoCollectionState >> badInterpret [

	^ badInterpret
]

{ #category : 'accessing' }
EchoCollectionState >> badInterpret: anObject [

	badInterpret := anObject
]

{ #category : 'accessing' }
EchoCollectionState >> badProgState [

	^ badProgState
]

{ #category : 'accessing' }
EchoCollectionState >> badProgState: anObject [

	badProgState := anObject
]

{ #category : 'as yet unclassified' }
EchoCollectionState >> collect [
	
	goodProgState add: ( DASTProgrammState new state: goodInterpret ).
	badProgState add: ( DASTProgrammState new state: badInterpret).
]

{ #category : 'as yet unclassified' }
EchoCollectionState >> good: interpreterGood bad: interpreterBad [

	goodInterpret := interpreterGood.
	badInterpret := interpreterBad
]

{ #category : 'accessing' }
EchoCollectionState >> goodInterpret [

	^ goodInterpret
]

{ #category : 'accessing' }
EchoCollectionState >> goodInterpret: anObject [

	goodInterpret := anObject
]

{ #category : 'accessing' }
EchoCollectionState >> goodProgState [

	^ goodProgState
]

{ #category : 'accessing' }
EchoCollectionState >> goodProgState: anObject [

	goodProgState := anObject
]

{ #category : 'initialization' }
EchoCollectionState >> initialize [ 


	goodProgState := OrderedCollection new.
	badProgState := OrderedCollection new.
]
