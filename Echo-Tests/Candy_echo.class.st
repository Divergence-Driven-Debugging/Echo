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

{ #category : 'testing' }
Candy_echo >> candy [

	sugar := 5 .
	chocolate := self chocolat .
	sugar > 5 ifTrue: [^ 'caramel' ].
	^ 'chocolate'
]

{ #category : 'reflective operations' }
Candy_echo >> doesNotUnderstand: aMessage [

	^ 5 
]
