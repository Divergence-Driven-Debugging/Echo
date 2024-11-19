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
		'echo',
		'menuTimeTravel',
		'echoResult'
	],
	#category : 'Echo-Presenters',
	#package : 'Echo',
	#tag : 'Presenters'
}

{ #category : 'instance creation' }
EchoDebuggerPresenter class >> on: aDomainObject echo: echo [
1halt.
	^ (self 
		newApplication: self currentApplication
		model: aDomainObject) echo: echo ; yourself .
]

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
	newLayout add: self echoLegend expand: false fill: false.
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

{ #category : 'accessing' }
EchoDebuggerPresenter >> echo: aEcho [

	echo := aEcho 
]

{ #category : 'layout' }
EchoDebuggerPresenter >> echoLegend [

	^ SpBoxLayout newLeftToRight
		  add: (self newButton
				   label: 'Assignments';
				   borderWidth: 0;
				   icon: (Smalltalk ui iconNamed: #instVarsSelected);
				   yourself)
		  expand: false fill: false;
		  add: (self newButton
				   label: 'Control flow';
				   borderWidth: 0;
				   icon: (Smalltalk ui iconNamed: #publish);
				   yourself)
		  expand: false fill: false;
		  add: (self newButton
				   label: 'Return values';
				   borderWidth: 0;
				   icon: (Smalltalk ui iconNamed: #refresh);
				   yourself)
		  expand: false fill: false;
		  yourself
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
EchoDebuggerPresenter >> initializeEventsBetweenStackOnTimeTravel: stack andCode: code [

	stack transmitDo: [ :programState |
		programState ifNotNil: [ self updateCodeTDD: code with: programState ] ].
	stack display: [ :programState |
		String streamContents: [ :str |
			programState currentContext printOn: str ] ]
]

{ #category : 'initialization' }
EchoDebuggerPresenter >> initializeMenu [

	menuTimeTravel := self newMenu.
	menuTimeTravel addItem: [ :item | item name: 'Time Travel Debugger at This Point'; "icon" action: [ self openTimeTravelDebuggerOn: divergencesList selectedItem  ]  ]
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

	referenceStack items: echoResult first.
	referenceStack selectFirst.
	
	modifiedStack items: echoResult second.
	modifiedStack selectFirst.
	
	
	divergencesList items: echoResult last.
	divergencesList transmitDo: [ :div |
		div ifNotNil: [
			referenceStack
				selectItem: (div reference state ifNil: [0]) 
				scrollToSelection: true.
			modifiedStack
				selectItem: (div modified state ifNil: [0]  )
				scrollToSelection: true ] ].
		
	self initializeMenu .
	divergencesList contextMenu: menuTimeTravel 
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

{ #category : 'initialization' }
EchoDebuggerPresenter >> openTimeTravelDebuggerOn: aEchoDivergence [

	| result |
	result := echo timeTravelGood: aEchoDivergence reference programCounter bad: aEchoDivergence modified programCounter.
	self flag: 'todo: il faut mettre a jour la stack et le code, il faut utiliser le initializeEventsBetweenStackOnTimeTravel. Pour les items il faut :
	referenceStack items: result first contextsStack.
	referenceStack selectFirst.
	
	modifiedStack items: result second contextsStack.
	modifiedStack selectFirst.
	 '
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
	echoResult := anEchoDebuggingResult
]

{ #category : 'layout' }
EchoDebuggerPresenter >> title [

	^ String streamContents: [ :str |
		  str << echoResult last size printString.
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

{ #category : 'as yet unclassified' }
EchoDebuggerPresenter >> updateCodeTDD: code with: context [


	code text: context sourceCode.
	code beForContext: context.
	code removeAllTextSegmentDecorations.

	code addTextSegmentDecoration:
		(SpTextPresenterDecorator forHighlight
			 interval:
				 (context currentNode start to: context currentNode stop + 1);
			 yourself)
]
