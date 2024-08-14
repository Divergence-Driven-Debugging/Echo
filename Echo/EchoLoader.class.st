Class {
	#name : 'EchoLoader',
	#superclass : 'Object',
	#instVars : [
		'baseline',
		'repository'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'accessing' }
EchoLoader >> baseline: aString [ 
	baseline := aString
]

{ #category : 'as yet unclassified' }
EchoLoader >> loadBad [

	| metacello packages |
	metacello := Metacello new
		             baseline: baseline;
		             repository: repository;
		             load.

	packages := (IceRepository repositoryNamed:
		             metacello projectSpec name) workingCopy packageNames .

	packages := packages collect: [ :p | p asPackage ].

	packages do: [ :p |
		p classes do: [ :c | (ReRenameClassRefactoring rename: c name to: (c name , '_echo')) execute ].
		p renameTo: p name , '_echo' ]
]

{ #category : 'as yet unclassified' }
EchoLoader >> loadGood [

	Metacello new
    baseline:  baseline;
    repository: repository ;
    load.
]

{ #category : 'accessing' }
EchoLoader >> repository: aString [

	repository := aString 
]
