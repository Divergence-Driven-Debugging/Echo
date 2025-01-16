Class {
	#name : 'EchoLoader',
	#superclass : 'Object',
	#instVars : [
		'baseline',
		'repository'
	],
	#category : 'Echo-Loader',
	#package : 'Echo',
	#tag : 'Loader'
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
		             onConflictUseIncoming;
		             load.

	packages := (IceRepository repositoryNamed:
		             'Pharo-Pillar-Bug') workingCopy packageNames.

	packages := packages collect: [ :p | p asPackage ].

	self renameEcho: packages 
]

{ #category : 'as yet unclassified' }
EchoLoader >> loadGood [

	Metacello new
    baseline:  baseline;
    repository: repository ;
	onConflictUseIncoming ;
    load.
]

{ #category : 'as yet unclassified' }
EchoLoader >> renameEcho: packages [

1halt.
packages do: [ :p |
		p classes do: [ :c | (ReRenameClassRefactoring rename: c name to: (c name , '_echo'))  execute ].
		p renameTo: p name , '_echo' ]
]

{ #category : 'accessing' }
EchoLoader >> repository: aString [

	repository := aString 
]
