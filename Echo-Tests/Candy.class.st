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
	chocolate := 60 .
	sugar > 5 ifTrue: [^ 'caramel' ].
	^ 'chocolate'
]
