Class {
	#name : 'Candy_echo',
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
Candy_echo >> cacao [
]

{ #category : 'as yet unclassified' }
Candy_echo >> cake [ 

	self cocoa 
]

{ #category : 'accessing - structure variables' }
Candy_echo >> cocoa [ 

	
]

{ #category : 'searching' }
Candy_echo >> doesNotUnderstand: aMessage [

	chocolate := 5
]

{ #category : 'searching' }
Candy_echo >> make [

	self chocolat.
	sugar := 4
]

{ #category : 'accessing' }
Candy_echo >> sugar [
	
	sugar := 2.
]
