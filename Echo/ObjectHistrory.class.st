Class {
	#name : 'ObjectHistrory',
	#superclass : 'Object',
	#instVars : [
		'hashId',
		'className',
		'dictionaryHistory',
		'variable'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'actualisation' }
ObjectHistrory >> actualiseHistory: aDictionary [

	dictionaryHistory
		at: (aDictionary at: 'timeStamp')
		put: (Dictionary new at: 'variable' put: (Dictionary new
					  at: 'name' put: (aDictionary at: 'name');
					  at: 'value' put: (aDictionary at: 'new value');
					  yourself))
]

{ #category : 'accessing' }
ObjectHistrory >> className: anObject [

	className := anObject
]

{ #category : 'accessing' }
ObjectHistrory >> dictionaryHistory [

	^ dictionaryHistory
]

{ #category : 'accessing' }
ObjectHistrory >> dictionaryHistory: anObject [

	dictionaryHistory := anObject
]

{ #category : 'accessing' }
ObjectHistrory >> hashId [

	^ hashId
]

{ #category : 'accessing' }
ObjectHistrory >> hashId: anObject [

	hashId := anObject
]

{ #category : 'testing' }
ObjectHistrory >> isEquivalentTo: anObjectDictionary [

	^ self className = anObjectDictionary className and: [
		  self dictionaryHistory = anObjectDictionary dictionaryHistory ]
]

{ #category : 'testing' }
ObjectHistrory >> isEquivalentTo: anObjectDictionary timeStampO: timestampO timeStampM: timeStampM [

	| originalHistory modifiedHistory |
	originalHistory := self dictionaryHistory keys select: [ :k | k < timestampO ].
	modifiedHistory := anObjectDictionary dictionaryHistory keys select: [ :k | k < timeStampM ].



	^ self className = anObjectDictionary className and: [
		  originalHistory = modifiedHistory ]
]

{ #category : 'accessing' }
ObjectHistrory >> recreateAt: aTimeStamp [

	| keys collectionOfValue |

	collectionOfValue := OrderedCollection new.
	
	keys := dictionaryHistory keys select: [ :t | t <= aTimeStamp ].
	keys do: [:k |collectionOfValue add:( dictionaryHistory at: k)].
	^ ObjectAtTime new className: className;
	allInstVar:collectionOfValue;
	yourself.

	
	
]
