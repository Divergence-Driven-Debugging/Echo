Class {
	#name : 'D3Presenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'divergenceLabel',
		'divergenceTable',
		'toolbar',
		'model',
		'flowDivergenceTable',
		'assignementDivergenceTable',
		'originStackList',
		'modifiedStackList',
		'modifiedCode',
		'originCode',
		'originSyncDiff',
		'modifiedSyncDiff',
		'resultTTQ',
		'manualQueryButton',
		'clearQueryButton',
		'addQueryButton',
		'currentQueryCode'
	],
	#category : 'Echo-Presenters',
	#package : 'Echo',
	#tag : 'Presenters'
}

{ #category : 'as yet unclassified' }
D3Presenter >> actualizeOffset [

	originSyncDiff text: '1'.
	modifiedSyncDiff text:'1'
]

{ #category : 'layout' }
D3Presenter >> defaultLayout [

	| newLayout |
	newLayout := SpBoxLayout newTopToBottom.
	newLayout add: (SpPanedLayout newTopToBottom
			 add: (DivergencePresenter owner: self on: model) ;
			 add: (StackCodePresenter owner: self on: model) ).
	^ newLayout
]

{ #category : 'as yet unclassified' }
D3Presenter >> initializeEventBetweenDiv: aDivTable [ 

aDivTable transmitDo: [ :programState |
		programState ifNotNil: [ originStackList selectItem: programState reference . modifiedStackList selectItem:programState modified ] ].
]

{ #category : 'initialization' }
D3Presenter >> initializeEventsBetweenStack: stack andCode: code [

stack transmitDo: [ :programState |
		programState ifNotNil: [ self updateCode: code with: programState ] ].
]

{ #category : 'accessing - model' }
D3Presenter >> setModelBeforeInitialization: anEchoDebuggingResult [

	model := anEchoDebuggingResult
]

{ #category : 'as yet unclassified' }
D3Presenter >> title [

	^ String streamContents: [ :str |
		  str << model divergences size printString.
		  str space.
		  str << 'divergences detected' ]
]
