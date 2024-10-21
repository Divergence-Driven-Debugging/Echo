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

{ #category : 'testing' }
Candy >> candy [

	sugar := 10 atRandom .
	chocolate := self chocolat .
	sugar > 5 ifTrue: [^ 'caramel' ].
	^ 'chocolate'
]

{ #category : 'reflective operations' }
Candy >> doesNotUnderstand: aMessage [

	^ 5 
]
