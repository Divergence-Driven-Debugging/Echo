"
An EchoTest is a test class for testing the behavior of Echo
"
Class {
	#name : 'EchoTest',
	#superclass : 'TestCase',
	#category : 'Echo-Tests-Core',
	#package : 'Echo-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
EchoTest >> testDivergenceOnAssignement [

	| echo execute |
	echo := Echo new.
 
	echo original: [Candy new sugar].
	echo modified: [Candy_echo new sugar].

	execute := echo execute.

	
	"oui il y a deux divergence car le sucre ne converge pas, mais je ne pense pas que ce soit logique "
	self assert: execute divergences size equals: 2
]

{ #category : 'tests' }
EchoTest >> testDivergenceOnAssignementWithFlow [

	| echo execute |
	echo := Echo new.

	echo original: [Candy new make].
	echo modified: [Candy_echo new make].



	execute := echo execute.
	
	1halt. 
	"oui 3 car le dnu nést pas capter par scopeo pour línstant"
	self assert: execute divergences size equals: 3
]

{ #category : 'tests' }
EchoTest >> testDivergenceOnflow [

	| echo execute |
	echo := Echo new.

	echo original: [Candy new cake].
	echo modified: [Candy_echo new cake].

	execute := echo execute.
	self assert: execute divergences size equals: 1
]

{ #category : 'tests' }
EchoTest >> testGoodCollectOfProgramState [

	| echo execute |
	echo := Echo new.

	echo original: [Candy new make].
	echo modified: [Candy_echo new make].
	echo packages: { 'Echo' asPackage }.


	execute := echo execute.
	self assert: execute referenceStack size equals: execute modifiedStack size
]

{ #category : 'tests' }
EchoTest >> testReconvergemceOnflow [

	| echo execute |
	echo := Echo new.

	echo original: [Candy new chocoGuimmauve ].
	echo modified: [Candy_echo new chocoGuimmauve ].

	execute := echo execute.
	self assert: execute divergences size equals: 5
]
