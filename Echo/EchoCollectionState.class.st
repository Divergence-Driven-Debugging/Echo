Class {
	#name : 'EchoCollectionState',
	#superclass : 'Object',
	#instVars : [
		'originalInterpret',
		'modifiedInterpret',
		'originalProgState',
		'modifiedProgState'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
EchoCollectionState >> collect [
	originalInterpret isDNU ifTrue: [ originalProgState last dnu: true. originalInterpret dnu: false ] .
	modifiedInterpret isDNU ifTrue: [ modifiedProgState last dnu: true. modifiedInterpret dnu: false ] .
	
	originalInterpret returnValue ifNotNil: [ originalProgState last returnValue: originalInterpret returnValue . originalInterpret returnValue: nil ] .
	modifiedInterpret returnValue ifNotNil: [ modifiedProgState last returnValue: modifiedInterpret returnValue . modifiedInterpret returnValue: nil ] .
	
	originalProgState add: ( DASTProgrammState new state: originalInterpret ).
	modifiedProgState add: ( DASTProgrammState new state: modifiedInterpret).
]

{ #category : 'initialization' }
EchoCollectionState >> initialize [ 


	originalProgState := OrderedCollection new.
	modifiedProgState := OrderedCollection new.
]

{ #category : 'accessing' }
EchoCollectionState >> modifiedInterpret [

	^ modifiedInterpret
]

{ #category : 'accessing' }
EchoCollectionState >> modifiedInterpret: anObject [

	modifiedInterpret := anObject
]

{ #category : 'accessing' }
EchoCollectionState >> modifiedProgState [

	^ modifiedProgState
]

{ #category : 'accessing' }
EchoCollectionState >> modifiedProgState: anObject [

	modifiedProgState := anObject
]

{ #category : 'as yet unclassified' }
EchoCollectionState >> original: interpreterGood modified: interpreterBad [

	originalInterpret := interpreterGood.
	modifiedInterpret := interpreterBad
]

{ #category : 'accessing' }
EchoCollectionState >> originalInterpret [

	^ originalInterpret
]

{ #category : 'accessing' }
EchoCollectionState >> originalInterpret: anObject [

	originalInterpret := anObject
]

{ #category : 'accessing' }
EchoCollectionState >> originalProgState [

	^ originalProgState
]

{ #category : 'accessing' }
EchoCollectionState >> originalProgState: anObject [

	originalProgState := anObject
]
