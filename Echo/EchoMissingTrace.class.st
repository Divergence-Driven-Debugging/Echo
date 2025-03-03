Class {
	#name : 'EchoMissingTrace',
	#superclass : 'Object',
	#category : 'Echo-Model',
	#package : 'Echo',
	#tag : 'Model'
}

{ #category : 'reflective operations' }
EchoMissingTrace >> doesNotUnderstand: aMessage [

	^ false
]

{ #category : 'accessing' }
EchoMissingTrace >> position [

	 ^ -1
]

{ #category : 'accessing' }
EchoMissingTrace >> variable [ 

	^ self
]
