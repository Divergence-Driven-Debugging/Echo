Class {
	#name : 'EchoDebuggerPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'buttonBar',
		'referenceStack',
		'referenceCode',
		'modifiedStack',
		'modifiedCode',
		'divergencesList',
		'echo'
	],
	#category : 'Echo-Presenters',
	#package : 'Echo',
	#tag : 'Presenters'
}

{ #category : 'layout' }
EchoDebuggerPresenter >> buttonBar [

	buttonBar := self newButtonBar.
	buttonBar
		placeAtStart;
		add: (self newButton
				 icon: (self application iconNamed: #smallAdd);
				 label: 'Add';
				 yourself);
		add: (self newButton
				 icon: (self application iconNamed: #smallDelete);
				 label: 'Delete';
				 yourself);
		add: (self newButton
				 icon: (self application iconNamed: #smallCopy);
				 label: 'Copy';
				 yourself).
	^ buttonBar
]

{ #category : 'layout' }
EchoDebuggerPresenter >> defaultLayout [

	| newLayout |
	newLayout := SpBoxLayout newTopToBottom.
	newLayout add: self buttonBar expand: false.
	newLayout add: (SpPanedLayout newTopToBottom
			 positionOfSlider: 30 percent;
			 add: self divergencesList;
			 add: (SpBoxLayout newLeftToRight
					  add: self referenceExecutionLayout;
					  add: self modifiedExecutionLayout;
					  yourself)).
	^ newLayout
]

{ #category : 'layout' }
EchoDebuggerPresenter >> divergencesList [

	^ divergencesList
]

{ #category : 'initialize' }
EchoDebuggerPresenter >> initializeEventsBetweenStack: stack andCode: code [

	stack transmitDo: [ :programState |
		programState ifNotNil: [ self updateCode: code with: programState ] ].
	stack display: [ :programState |
		String streamContents: [ :str |
			programState currentContext printOn: str ] ]
]

{ #category : 'initialize' }
EchoDebuggerPresenter >> initializePresenters [

	divergencesList := self newList.
	divergencesList activateOnDoubleClick whenActivatedDo: [ :div |
		div selectedItem inspect ].
	divergencesList displayIcon: [ :elem | elem icon].
	"divergencesList display:  [ :div | div printString ]."
	

	modifiedStack := self newList.
	modifiedCode := self newCode.
	modifiedCode beNotEditable.
	self
		initializeEventsBetweenStack: modifiedStack
		andCode: modifiedCode.

	referenceStack := self newList.
	referenceCode := self newCode.
	referenceCode beNotEditable.
	self
		initializeEventsBetweenStack: referenceStack
		andCode: referenceCode.

	referenceStack items: echo first.
	referenceStack selectFirst.
	modifiedStack items: echo second.
	modifiedStack selectFirst.
	divergencesList items: echo last.
	divergencesList transmitDo: [ :div |
		div ifNotNil: [1haltOnce. 
			referenceStack
				selectItem: (div reference state ifNil: [0]) 
				scrollToSelection: true.
			modifiedStack
				selectItem: (div modified state ifNil: [0]  )
				scrollToSelection: true ] ].
]

{ #category : 'layout' }
EchoDebuggerPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self title;
		initialExtent: 700 @ 600
]

{ #category : 'layout' }
EchoDebuggerPresenter >> modifiedExecutionLayout [

	^ SpBoxLayout newTopToBottom	
		  add: 'Modified execution' expand: false fill: false padding: 5;		 
		  add: modifiedStack;
		  add: modifiedCode;
		  yourself
]

{ #category : 'layout' }
EchoDebuggerPresenter >> referenceExecutionLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Reference execution' expand: false fill: false padding: 5;	
		  add: referenceStack;
		  add: referenceCode;
		  yourself
]

{ #category : 'initialize' }
EchoDebuggerPresenter >> setModelBeforeInitialization: anEchoDebuggingResult [
	echo := anEchoDebuggingResult
]

{ #category : 'layout' }
EchoDebuggerPresenter >> title [

	^ String streamContents: [ :str |
		  str << echo last size printString.
		  str space.
		  str << 'divergences detected' ]
]

{ #category : 'initialize' }
EchoDebuggerPresenter >> updateCode: code with: programState [

	| context |
	context := programState currentContext.
	code text: context sourceCode.
	code beForContext: context.
	code removeAllTextSegmentDecorations.

	code addTextSegmentDecoration:
		(SpTextPresenterDecorator forHighlight
			 interval:
				 (programState node start to: programState node stop + 1);
			 yourself)
]
