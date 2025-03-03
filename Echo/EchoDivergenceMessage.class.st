"
collectBad is the collection of bad program state to reconverge at node reference
collectGood is the collection of bad program state to reconverge at node modified
"
Class {
	#name : 'EchoDivergenceMessage',
	#superclass : 'EchoDivergence',
	#instVars : [
		'collectGood',
		'collectBad',
		'linkedDivergence'
	],
	#category : 'Echo-Model',
	#package : 'Echo',
	#tag : 'Model'
}

{ #category : 'accessing' }
EchoDivergenceMessage >> collectBad [

	^ collectBad
]

{ #category : 'accessing' }
EchoDivergenceMessage >> collectBad: aCollection [
	" i'm the collection of the program states who go on convergence on the bad version to these original state"
	collectBad:= aCollection .
]

{ #category : 'accessing' }
EchoDivergenceMessage >> collectGood [

	^ collectGood
]

{ #category : 'accessing' }
EchoDivergenceMessage >> collectGood: aCollection [
	" i'm the collection of the program states who go on convergence on the good version to these modified state"
	
	collectGood := aCollection .
]

{ #category : 'accessing' }
EchoDivergenceMessage >> description [
	
	^ 'Divergence on Flow : reference execution send  #', reference selector , ' modified send #', modified selector 
]

{ #category : 'accessing' }
EchoDivergenceMessage >> icon [
	^Smalltalk ui iconNamed: #publish
]

{ #category : 'initialization' }
EchoDivergenceMessage >> initialize [

	 super initialize.
	 linkedDivergence := OrderedCollection new
]

{ #category : 'testing' }
EchoDivergenceMessage >> isMessage [ 

	^ true 
]

{ #category : 'accessing' }
EchoDivergenceMessage >> linkedDivergence [

	^ linkedDivergence
]

{ #category : 'accessing' }
EchoDivergenceMessage >> linkedDivergence: anObject [

	linkedDivergence := anObject
]

{ #category : 'printing' }
EchoDivergenceMessage >> printOn: str [

		str << '[Message] '.
		str space.
		str << reference selector.
		str << ' <-> '.
		str << modified selector.
		^ self .



]

{ #category : 'api - selection' }
EchoDivergenceMessage >> selectItem: modifiedStack [

"	1 haltOnce."

	^ (modifiedStack items select: [ :s |
		   s programCounter = (self modified programCounter + self shift) ])
		  first
]
