Class {
	#name : 'QueryBuilderPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'addButton',
		'clearButton',
		'runButton',
		'notebook',
		'removeButton',
		'model',
		'manualButton'
	],
	#category : 'Echo-Presenters',
	#package : 'Echo',
	#tag : 'Presenters'
}

{ #category : 'initialization' }
QueryBuilderPresenter >> addQueryToLayout [
	
	self layout add: (QueryLinePresenter owner: self on: model)
]

{ #category : 'initialization' }
QueryBuilderPresenter >> clearQuery [

	| childrenToRemove |
	childrenToRemove := self layout children select: [ :d | d class = QueryLinePresenter ].
	childrenToRemove do:[:d | self layout remove: d].
]

{ #category : 'initialization' }
QueryBuilderPresenter >> defaultLayout [

    	^ SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
				   add: addButton;
				   add: clearButton;
				   add: manualButton);
		yourself		
]

{ #category : 'initialization' }
QueryBuilderPresenter >> initializePresenters [

	addButton := self newButton.
	addButton
		action: [ self addQueryToLayout ];
		label: 'Add a presenter to the layout';
		icon: (self iconNamed: #smallAdd).
		
	manualButton := self newButton .
	
	
	clearButton := self newButton .
	clearButton label: 'clear Query';
					action:[ self clearQuery ];
				   borderWidth: 1;
				   icon: (Smalltalk ui iconNamed: #smallDelete).
		

		
]

{ #category : 'accessing - model' }
QueryBuilderPresenter >> setModelBeforeInitialization: anEchoDebuggingResult [

	model := anEchoDebuggingResult
]
