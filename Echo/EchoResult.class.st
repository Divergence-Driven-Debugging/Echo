Class {
	#name : 'EchoResult',
	#superclass : 'Object',
	#instVars : [
		'divergences',
		'referenceStack',
		'modifiedStack',
		'flowDivergences',
		'assignementDivergences',
		'query'
	],
	#category : 'Echo-Model',
	#package : 'Echo',
	#tag : 'Model'
}

{ #category : 'adding' }
EchoResult >> addQuery [ 


	query add: EchoQuery new.
]

{ #category : 'adding' }
EchoResult >> addQuery: aQuery [

	query add: aQuery
]

{ #category : 'accesing' }
EchoResult >> assignementDivergences [
	
	^ assignementDivergences 
]

{ #category : 'as yet unclassified' }
EchoResult >> assignementDivergences: aDivergence [


	assignementDivergences add: aDivergence .
]

{ #category : 'as yet unclassified' }
EchoResult >> availableProperties [
	
	^ { 'object'. 'method' . 'assignement' }
]

{ #category : 'adding' }
EchoResult >> clearQuery [ 


	query removeAll .
]

{ #category : 'accessing' }
EchoResult >> divergences [

	^ divergences 
]

{ #category : 'accessing' }
EchoResult >> divergences: anObject [

	divergences := anObject.
	self linkedDivergence
]

{ #category : 'accessing' }
EchoResult >> firstDivergences [
	"return the first divergence in the program, they can be states or flow"

	^ self headDivergence
]

{ #category : 'accessing' }
EchoResult >> firstFlowDivergences [
	"return the first flow divergence in the program"

	^ self flowDivergences first
]

{ #category : 'accessing' }
EchoResult >> firstStateDivergences [
	"return the first state divergence in the program"

	^ self assignementDivergences first
]

{ #category : 'as yet unclassified' }
EchoResult >> flowDivergences [
	
	^ flowDivergences
]

{ #category : 'accessing' }
EchoResult >> flowDivergences: anObject [

	flowDivergences := anObject
]

{ #category : 'accessing' }
EchoResult >> headDivergence [

  ^ divergences reject: [ :d | d isLinkedToOtherDiv ]
]

{ #category : 'as yet unclassified' }
EchoResult >> initialize [ 

	assignementDivergences := OrderedCollection new.
	flowDivergences := OrderedCollection new.
	query := OrderedCollection new.
]

{ #category : 'accessing' }
EchoResult >> linkedDivergence [

	| listOfMessage listOfAssigne  |
	self flag: 'attention si dnu et pas de message a gauche dans un setteur on ped línfo '.
	listOfMessage := divergences select: [ :d | d isMessage ].
	listOfAssigne := divergences select: [ :d | d isAssignment ].
	
	"en gros la on va regarder si reference assigne et entre la position de good et de bad "
	
	listOfMessage do: [ :m | m linkedDivergence addAll: (listOfAssigne select: [ :a |
	 a reference position > m reference position and: [
		 a reference position < ((m collectGood atLast: 1 ifAbsent: ( EchoMissingTrace new )) position) ] ]). m linkedDivergence do: [:d | d isLinkedToOtherDiv: true]].

	listOfMessage do: [ :m | m linkedDivergence addAll: (listOfAssigne select: [ :a |
	 a modified position > m modified position and: [
		 a modified position < ((m collectBad atLast: 1 ifAbsent: ( EchoMissingTrace new )) position )] ]). m linkedDivergence do: [:d | d isLinkedToOtherDiv: true]]


	
]

{ #category : 'accessing' }
EchoResult >> modifiedStack [

	^ modifiedStack
]

{ #category : 'accessing' }
EchoResult >> modifiedStack: anObject [

	modifiedStack := anObject
]

{ #category : 'accessing' }
EchoResult >> query [

	^ query
]

{ #category : 'accessing' }
EchoResult >> query: anObject [

	query := anObject
]

{ #category : 'accessing' }
EchoResult >> referenceStack [

	^ referenceStack
]

{ #category : 'accessing' }
EchoResult >> referenceStack: anObject [

	referenceStack := anObject
]

{ #category : 'accessing' }
EchoResult >> updateDivergence [

	divergences := OrderedCollection new.
	divergences := divergences , self assignementDivergences , self flowDivergences .
]
