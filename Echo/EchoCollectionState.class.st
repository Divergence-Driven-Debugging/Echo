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

{ #category : 'initialization' }
EchoCollectionState >> initialize [ 


	goodProgState := OrderedCollection new.
	badProgState := OrderedCollection new.
]
