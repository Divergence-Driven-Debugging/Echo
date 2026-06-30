Class {
	#name : 'StackCodePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'toolbar',
		'model',
		'originStackList',
		'modifiedStackList',
		'modifiedCode',
		'originCode'
	],
	#category : 'Echo-Presenters',
	#package : 'Echo',
	#tag : 'Presenters'
}

{ #category : 'layout' }
StackCodePresenter >> defaultLayout [

^ SpPanedLayout newTopToBottom
		  add: (SpPanedLayout new
				   add: (SpBoxLayout newTopToBottom add: toolbar);
				   add: (SpBoxLayout newTopToBottom
						    "add: self intializeSynchNumber;"
						    add: (SpPanedLayout newLeftToRight
								     add: originStackList;
								     add: modifiedStackList)));
		  add: (SpPanedLayout newTopToBottom
				   add: (SpPanedLayout newLeftToRight
						    add: originCode;
						    add: modifiedCode);
				   add: self newToolbar)
]

{ #category : 'initialization' }
StackCodePresenter >> initializeButtonToolBar [

	^ SpBoxLayout newLeftToRight
		  add: (self newButton
				   label: 'step Left';
				   action: [ self stepLeft ];
				   borderWidth: 0;
				   icon: (Smalltalk ui iconNamed: #into);
				   yourself)
		  expand: false fill: false;
		  add: (self newButton
				   label: 'step Sync';
				   action: [ self stepSync ];
				   borderWidth: 0;
				   icon: (Smalltalk ui iconNamed: #into);
				   yourself)
		  expand: false fill: false;
		  add: (self newButton
				   label: 'step Right';
					action:[self stepRight];
				   borderWidth: 0;
				   icon: (Smalltalk ui iconNamed: #into);
				   yourself)
		  expand: false fill: false;
		  add: (self newButton
				   label: 'restart';
					action:[self restart];
				   borderWidth: 0;
				   icon: (Smalltalk ui iconNamed: #refreshCircling);
				   yourself)
		  expand: false fill: false;
		  yourself
]

{ #category : 'accessing - model' }
StackCodePresenter >> initializeEventsBetweenStack: stack andCode: code [

stack transmitDo: [ :programState |
		programState ifNotNil: [ self updateCode: code with: programState ] ].
]

{ #category : 'initialization' }
StackCodePresenter >> initializePresenters [ 


	self tableStack .
	self intializeToolBar.

		
]

{ #category : 'initialization' }
StackCodePresenter >> intializeToolBar [

	toolbar := SpBoxLayout newTopToBottom 
		           add: self initializeButtonToolBar ;
		           yourself
]

{ #category : 'initialization' }
StackCodePresenter >> restart [

	originStackList selectFirst.
	modifiedStackList selectFirst
]

{ #category : 'accessing - model' }
StackCodePresenter >> setModelBeforeInitialization: anEchoDebuggingResult [

	model := anEchoDebuggingResult
]

{ #category : 'initialization' }
StackCodePresenter >> stepLeft [

	originStackList selectedItem  ifNil: [ originStackList selectFirst ] ifNotNil: [ originStackList selectIndex: ((originStackList items find: (originStackList selectedItem)) + 1) ]
]

{ #category : 'initialization' }
StackCodePresenter >> stepRight [

	modifiedStackList selectedItem  ifNil: [ modifiedStackList selectFirst ] ifNotNil: [ modifiedStackList selectIndex: ((modifiedStackList items find: (modifiedStackList selectedItem)) + 1) ]
]

{ #category : 'initialization' }
StackCodePresenter >> stepSync [


	modifiedStackList selectedItem  ifNil: [ modifiedStackList selectFirst ] ifNotNil: [ modifiedStackList selectIndex: ((modifiedStackList items find: (modifiedStackList selectedItem)) + 1) ].
	originStackList selectedItem  ifNil: [ originStackList selectFirst ] ifNotNil: [ originStackList selectIndex: ((originStackList items find: (originStackList selectedItem)) + 1) ].

]

{ #category : 'as yet unclassified' }
StackCodePresenter >> tableStack [

	originStackList := self newTable.
	originStackList items: model referenceStack.
	originStackList addColumn: ((SpStringTableColumn
			  title: 'PC'
			  evaluated: [ :elem | elem timestamp ])
			 width: 30;
			 yourself).
	originStackList addColumn:
		(SpStringTableColumn title: 'Context' evaluated: [ :programState |
			 String streamContents: [ :str | programState printOn: str ] ]).


	originStackList activateOnDoubleClick whenActivatedDo: [ :div |
		div selectedItem inspect ].
	originStackList selectFirst.

	originCode := self newCode.
	originCode beNotEditable.
	self
		initializeEventsBetweenStack: originStackList
		andCode: originCode.

	modifiedStackList := self newTable.
	modifiedStackList items: model modifiedStack.

	modifiedStackList addColumn: ((SpStringTableColumn
			  title: 'PC'
			  evaluated: [ :elem | elem timestamp ])
			 width: 30;
			 yourself).
	modifiedStackList addColumn:
		(SpStringTableColumn title: 'Context' evaluated: [ :programState |
			 String streamContents: [ :str | programState printOn: str ] ]).


	modifiedStackList activateOnDoubleClick whenActivatedDo: [ :div |
		div selectedItem inspect ].
	modifiedStackList selectFirst.








	modifiedCode := self newCode.
	modifiedCode beNotEditable.
	self
		initializeEventsBetweenStack: modifiedStackList
		andCode: modifiedCode
]

{ #category : 'accessing - model' }
StackCodePresenter >> updateCode: code with: programState [

	code text: programState node sourceCode.
	code removeAllTextSegmentDecorations
]
