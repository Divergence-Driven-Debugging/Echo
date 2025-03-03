Class {
	#name : 'EchoResult',
	#superclass : 'Object',
	#instVars : [
		'divergences',
		'referenceStack',
		'modifiedStack'
	],
	#category : 'Echo-Model',
	#package : 'Echo',
	#tag : 'Model'
}

{ #category : 'accessing' }
EchoResult >> divergences [

	^ divergences 
]

{ #category : 'accessing' }
EchoResult >> divergences: anObject [

	divergences := anObject.
	self linkedDivergence
]

{ #category : 'initialization' }
EchoResult >> iconForDivergence: aDivergence [

	^ aDivergence icon
]

{ #category : 'accessing' }
EchoResult >> linkedDivergence [

	| listOfMessage listOfAssigne candidate |
	self flag: 'attention si dnu et pas de message a gauche dans un setteur on ped línfo '.
	listOfMessage := divergences select: [ :d | d isMessage ].
	listOfAssigne := divergences select: [ :d | d isAssignment ].
	
	"en gros la on va regarder si reference assigne et entre la position de good et de bad "
	
	listOfMessage do: [ :m | m linkedDivergence addAll: (listOfAssigne select: [ :a |
	 a reference position > m reference position and: [
		 a reference position < ((m collectGood atLast: 1 ifAbsent: ( EchoMissingTrace new )) position) ] ])].

	listOfMessage do: [ :m | m linkedDivergence addAll: (listOfAssigne select: [ :a |
	 a modified position > m modified position and: [
		 a modified position < ((m collectBad atLast: 1 ifAbsent: ( EchoMissingTrace new )) position )] ])]
	
]

{ #category : 'accessing' }
EchoResult >> modifiedStack [

	^ modifiedStack
]

{ #category : 'accessing' }
EchoResult >> modifiedStack: anObject [

	modifiedStack := anObject
]

{ #category : 'accessing' }
EchoResult >> referenceStack [

	^ referenceStack
]

{ #category : 'accessing' }
EchoResult >> referenceStack: anObject [

	referenceStack := anObject
]

{ #category : 'initialization' }
EchoResult >> updateCode: code with: trace [

	 self flag: 'why +1 pour le stop'.

	 code beForMethod: trace node methodNode compiledMethod.
	 code text: trace node methodNode sourceCode.
	 code removeAllTextSegmentDecorations.
	 code clearSelection.


	 code addTextSegmentDecoration:
		 (SpTextPresenterDecorator forHighlight
			  interval: (trace node start to: trace node stop + 1);
			  yourself)
]

{ #category : 'as yet unclassified' }
EchoResult >> updateModifiedStack: modifiedStack whiteDiv: div [

1haltOnce.
]

{ #category : 'as yet unclassified' }
EchoResult >> updateReferenceStack: referenceStack whiteDiv: div [

	1haltOnce.
]
