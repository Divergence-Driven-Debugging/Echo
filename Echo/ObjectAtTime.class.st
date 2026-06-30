Class {
	#name : 'ObjectAtTime',
	#superclass : 'Object',
	#instVars : [
		'className',
		'allInstVarNames',
		'value'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
ObjectAtTime >> allInstVar: aCollection [


	allInstVarNames:= aCollection collect: [ :d | d at: 'name' ].
	value := aCollection
]

{ #category : 'accessing - instances and variables' }
ObjectAtTime >> allInstVarNames [

	^ allInstVarNames
]

{ #category : 'initialization' }
ObjectAtTime >> className [ 

	^ className 
]

{ #category : 'accessing' }
ObjectAtTime >> className: anObject [

	className := anObject
]
