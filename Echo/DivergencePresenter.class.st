Class {
	#name : 'DivergencePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'divergenceLabel',
		'divergenceTable',
		'model',
		'flowDivergenceTable',
		'assignementDivergenceTable',
		'addQueryButton',
		'clearQueryButton',
		'manualQueryButton',
		'resultTTQ',
		'currentQueryCode'
	],
	#category : 'Echo-Presenters',
	#package : 'Echo',
	#tag : 'Presenters'
}

{ #category : 'as yet unclassified' }
DivergencePresenter >> addQuery [ 

	model addQuery.
	
]

{ #category : 'as yet unclassified' }
DivergencePresenter >> clearQuery [ 

	model clearQuery.
	
]

{ #category : 'accessing - model' }
DivergencePresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout new
				   add: 'flow divergences';
				   add: flowDivergenceTable;
				   yourself);
		  add: (SpBoxLayout new
				   add: 'assignement divergences';
				   add: assignementDivergenceTable;
				   yourself);
		  add: (QueryBuilderPresenter owner:self on:model);
		  yourself
]

{ #category : 'as yet unclassified' }
DivergencePresenter >> initializePresenters [ 

	self tableDivergence.
	self initializeTTQ .

		
]

{ #category : 'as yet unclassified' }
DivergencePresenter >> initializeTTQ [

	resultTTQ := self newList .
	currentQueryCode := self newCode .
	manualQueryButton := self newButton .
	clearQueryButton := self newButton .
	addQueryButton := self newButton .
	
	
	
	addQueryButton label: 'add Query';
				   action: [ self addQuery ];
				   borderWidth: 1;
				   icon: (Smalltalk ui iconNamed: #add).
				
				
		clearQueryButton label: 'clear Query';
				   action: [ self clearQuery ];
				   borderWidth: 1;
				   icon: (Smalltalk ui iconNamed: #smallDelete).
				
	resultTTQ items: model query.
	
	
	


	
]

{ #category : 'as yet unclassified' }
DivergencePresenter >> layoutTTQ [

	^ SpBoxLayout new
		  add: 'TTQ Section'
		  expand: false
		  fill: false
		  padding: 5;
		  spacing: 5;
		  add: (SpBoxLayout newLeftToRight
				   add: addQueryButton;
				   add: clearQueryButton;
				   add: manualQueryButton);
		  add: resultTTQ;
		  add: 'current query code';
		  add: currentQueryCode;
		  yourself
]

{ #category : 'accessing - model' }
DivergencePresenter >> setModelBeforeInitialization: anEchoDebuggingResult [

	model := anEchoDebuggingResult
]

{ #category : 'accessing - model' }
DivergencePresenter >> tableDivergence [

	flowDivergenceTable := self newTable.

	flowDivergenceTable
		items: model flowDivergences;
		beResizable.

	flowDivergenceTable activateOnDoubleClick whenActivatedDo: [ :div |
		div selectedItem inspect ].



	assignementDivergenceTable := self newTable.

	assignementDivergenceTable
		items: model assignementDivergences;
		beResizable.

	assignementDivergenceTable activateOnDoubleClick whenActivatedDo: [
		:div | div selectedItem inspect ].

]
