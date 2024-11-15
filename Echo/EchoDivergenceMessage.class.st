Class {
	#name : 'EchoDivergenceMessage',
	#superclass : 'EchoDivergence',
	#instVars : [
		'collectGood',
		'collectBad'
	],
	#category : 'Echo-Core',
	#package : 'Echo',
	#tag : 'Core'
}

{ #category : 'accessing' }
EchoDivergenceMessage >> collectBad: aCollection [
	" i'm the collection of the program states who go on convergence on the bad version to these original state"
	collectBad:= aCollection .
]

{ #category : 'accessing' }
EchoDivergenceMessage >> collectGood: aCollection [
	" i'm the collection of the program states who go on convergence on the good version to these modified state"
	
	collectGood := aCollection .
]

{ #category : 'printing' }
EchoDivergenceMessage >> printOn: str [

		str << '[Message] '.
		str space.
		str << reference node selector.
		str << ' <-> '.
		str << modified node selector.
		^ self .



]

{ #category : 'api - selection' }
EchoDivergenceMessage >> selectItem: modifiedStack [

	1 haltOnce.

	^ (modifiedStack items select: [ :s |
		   s programCounter = (self modified programCounter + self shift) ])
		  first
]
