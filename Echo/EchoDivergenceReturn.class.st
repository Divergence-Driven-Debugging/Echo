Class {
	#name : 'EchoDivergenceReturn',
	#superclass : 'EchoDivergence',
	#instVars : [
		'returnGood',
		'returnBad'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'accessing' }
EchoDivergenceReturn >> returnBad [

	^ returnBad
]

{ #category : 'accessing' }
EchoDivergenceReturn >> returnBad: anObject [

	returnBad := anObject
]

{ #category : 'accessing' }
EchoDivergenceReturn >> returnGood [

	^ returnGood
]

{ #category : 'accessing' }
EchoDivergenceReturn >> returnGood: anObject [

	returnGood := anObject
]
