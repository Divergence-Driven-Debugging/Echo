Class {
	#name : 'EchoLoaderTest',
	#superclass : 'TestCase',
	#category : 'Echo-Tests-Core',
	#package : 'Echo-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
EchoLoaderTest >> testLoadGoodAssignement [

| echo execute assignement |
	echo := Echo new.

	echo original: [Candy new make].
	echo modified: [Candy_echo new make].
	echo packages: { 'Echo' asPackage }.


	execute := echo execute.
	assignement := execute referenceStack select: [ :t | t isAssignment ].
	self assert: assignement size equals: 2 .
	
	assignement := execute modifiedStack select: [ :t | t isAssignment ].
	self assert: assignement size equals: 2 
]

{ #category : 'tests' }
EchoLoaderTest >> testLoadGoodMessage [

| echo execute message |
	echo := Echo new.

	echo original: [Candy new ].
	echo modified: [Candy_echo new ].
	echo packages: { 'Echo' asPackage }.


	execute := echo execute.
	message := execute referenceStack select: [ :t | t isMessage ].
	self assert: message size equals: 2 .
	
	message := execute modifiedStack select: [ :t | t isMessage ].
	self assert: message size equals: 2 
]
