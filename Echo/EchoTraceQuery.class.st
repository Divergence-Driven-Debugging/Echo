Class {
	#name : 'EchoTraceQuery',
	#superclass : 'EchoTraceRecorder',
	#category : 'Echo-Model',
	#package : 'Echo',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
EchoTraceQuery >> accesTo: anObject [

"give all the place where an object is being acces"
]

{ #category : 'as yet unclassified' }
EchoTraceQuery >> methodCall: aMethod [

	"return all the place where aMethod is call during the execution"
]

{ #category : 'as yet unclassified' }
EchoTraceQuery >> objectCreation: aClass [

"return all the trace whit the creation of an object with this types"
]

{ #category : 'as yet unclassified' }
EchoTraceQuery >> resultOfMethod: aTrace [

"renvoie les infos de retour dune methode"
]
