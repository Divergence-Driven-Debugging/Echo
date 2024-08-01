Class {
	#name : 'EchoAlgo',
	#superclass : 'Object',
	#instVars : [
		'interpreterGood',
		'interpreterBad',
		'dictionaryGoodObject',
		'dictionaryConvDiv'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
EchoAlgo >> algoDiff [

	((interpreterGood currentNode isEquivalentTo:
		  interpreterBad currentNode) and: self objectSlotDif) ifFalse: [
		^ self divergence ].
	self convergence
]

{ #category : 'as yet unclassified' }
EchoAlgo >> convergence [

	| converge |
	converge := dictionaryConvDiv at: interpreterGood receiver ifAbsentPut: true.
	converge ifTrue: [ ^ self ].
	dictionaryConvDiv at: interpreterGood receiver put: true.
	1 halt
]

{ #category : 'as yet unclassified' }
EchoAlgo >> divergence [

	| divergence |
	divergence := dictionaryConvDiv at: interpreterGood receiver ifAbsentPut: true.
	divergence ifFalse: [ ^ self ].
	dictionaryConvDiv at: interpreterGood receiver put: false.
	1 halt
]

{ #category : 'as yet unclassified' }
EchoAlgo >> good: aInterpreterGood bad: aInterpreterBad [ 

	interpreterGood := aInterpreterGood.
	interpreterBad := aInterpreterBad
]

{ #category : 'initialization' }
EchoAlgo >> initialize [

	dictionaryGoodObject := Dictionary new.
	dictionaryConvDiv := Dictionary new.
]

{ #category : 'as yet unclassified' }
EchoAlgo >> objectSlotDif [

	dictionaryGoodObject
		at: interpreterGood receiver
		put: interpreterGood receiver slotsValue.
	^ (dictionaryGoodObject at: interpreterGood receiver) includesAll:
		  interpreterBad receiver slotsValue
]
