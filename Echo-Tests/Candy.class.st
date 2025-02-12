Class {
	#name : 'Candy',
	#superclass : 'Object',
	#instVars : [
		'sugar',
		'chocolate'
	],
	#category : 'Echo-Tests-Core',
	#package : 'Echo-Tests',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
Candy >> cacao [ 
]

{ #category : 'as yet unclassified' }
Candy >> cake [

	self cacao
]

{ #category : 'as yet unclassified' }
Candy >> chocoGuimmauve [

	self chocolat .
	self guimmauve 
]

{ #category : 'as yet unclassified' }
Candy >> chocolat [

	chocolate := 5
]

{ #category : 'as yet unclassified' }
Candy >> guimmauve [

	self sugar.
]

{ #category : 'as yet unclassified' }
Candy >> make [

	self chocolat.
	sugar := 4
]

{ #category : 'accessing' }
Candy >> sugar [
	
	sugar := 3.
]
