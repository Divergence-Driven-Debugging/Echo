Class {
	#name : 'EchoDebuggerPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'buttonBar',
		'referenceStack',
		'referenceCode',
		'modifiedStack',
		'modifiedCode',
		'echo',
		'menuTimeTravel',
		'echoResult',
		'divergencesTable'
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
			 add: divergencesTable ;
			 add: (SpBoxLayout newLeftToRight
					  add: self referenceExecutionLayout;
					  add: self modifiedExecutionLayout;
					  yourself)).
	^ newLayout
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

{ #category : 'initialization' }
EchoDebuggerPresenter >> initializeDivergenceTable [

	divergencesTable := self newTable.
	divergencesTable activateOnDoubleClick whenActivatedDo: [ :div |
		div selectedItem inspect ].
	divergencesTable addColumn: (SpIndexTableColumn new width: 20; yourself).
	divergencesTable addColumn: (SpImageTableColumn new width: 25; evaluated: [ :elem | elem icon ]; yourself).
	divergencesTable addColumn: ((SpStringTableColumn title: 'Reference' evaluated: [ :elem | self printAutoTypeEcho: elem reference]) width: 200; yourself).
	divergencesTable addColumn: ((SpStringTableColumn title: 'Modified' evaluated: [ :elem | self printAutoTypeEcho: elem modified]) width: 200; yourself).
	divergencesTable addColumn: (SpLinkTableColumn new width: 50; evaluated: [ :elem | 'jump' ]; action:[:row| row inspect]; yourself).
	"divergencesTable displayIcon: [ :elem | elem icon]."
	

	divergencesTable items: echoResult last.
	divergencesTable transmitDo: [ :div |
		div ifNotNil: [
			referenceStack
				selectItem: (div reference state ifNil: [0]) 
				scrollToSelection: true.
			modifiedStack
				selectItem: (div modified state ifNil: [0]  )
				scrollToSelection: true ] ].
		
	self initializeMenu.
	divergencesTable contextMenu: menuTimeTravel 
]

{ #category : 'initialization' }
EchoDebuggerPresenter >> initializeEventsBetweenStack: stack andCode: code [

	stack transmitDo: [ :programState |
		programState ifNotNil: [ self updateCode: code with: programState ] ].
]

{ #category : 'initialization' }
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
	menuTimeTravel addItem: [ :item |
		item
			name: 'Time Travel Debugger at This Point';
			"icon"action: [
				self openTimeTravelDebuggerOn: divergencesTable selectedItem ] ]
]

{ #category : 'initialization' }
EchoDebuggerPresenter >> initializePresenters [

	modifiedStack := self newTable.
	modifiedCode := self newCode.
	modifiedCode beNotEditable.
	self
		initializeEventsBetweenStack: modifiedStack
		andCode: modifiedCode.

	referenceStack := self newTable.
	referenceCode := self newCode.
	referenceCode beNotEditable.
	self
		initializeEventsBetweenStack: referenceStack
		andCode: referenceCode.

	referenceStack items: echoResult first.
	referenceStack activateOnDoubleClick whenActivatedDo: [ :div |
		div selectedItem inspect ].
	referenceStack selectFirst.
	referenceStack addColumn: ((SpStringTableColumn
			  title: 'PC'
			  evaluated: [ :elem | elem programCounter ])
			 width: 30;
			 yourself).
	referenceStack addColumn:
		(SpStringTableColumn title: 'Context' evaluated: [ :programState |
			 self printStringWithoutEcho: (String streamContents: [ :str |
					  programState currentContext printOn: str ]) ]).


	modifiedStack items: echoResult second.
	modifiedStack activateOnDoubleClick whenActivatedDo: [ :div |
		div selectedItem inspect ].
	modifiedStack selectFirst.
	modifiedStack addColumn: ((SpStringTableColumn
			  title: 'PC'
			  evaluated: [ :elem | elem programCounter ])
			 width: 30;
			 yourself).
	modifiedStack addColumn:
		(SpStringTableColumn title: 'Context' evaluated: [ :programState |
			 self printStringWithoutEcho: (String streamContents: [ :str |
					  programState currentContext printOn: str ]) ]).

	self initializeDivergenceTable
]

{ #category : 'initialization' }
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

{ #category : 'printing' }
EchoDebuggerPresenter >> printAutoTypeEcho: anAutoTypeEcho [

	^ String streamContents: [ :stream |
		  stream << '[pc: '.
		  anAutoTypeEcho programCounter printOn: stream.
		  stream << ']'.
		  stream space.
		  stream
		  << (self printStringWithoutEcho: anAutoTypeEcho node sourceCode) ]
]

{ #category : 'printing' }
EchoDebuggerPresenter >> printStringWithoutEcho: aString [

	^ aString copyReplaceAll: '_echo' with: ''
]

{ #category : 'layout' }
EchoDebuggerPresenter >> referenceExecutionLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Reference execution' expand: false fill: false padding: 5;	
		  add: referenceStack;
		  add: referenceCode;
		  yourself
]

{ #category : 'initialization' }
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

{ #category : 'initialization' }
EchoDebuggerPresenter >> updateCode: code with: programState [

	| context nodeSource sourceDelta start stop |
	context := programState currentContext.
	code text: (self printStringWithoutEcho: context sourceCode).
	code beForContext: context.
	code removeAllTextSegmentDecorations.


	nodeSource := programState node sourceCode.
	sourceDelta := ((context sourceCode copyFrom: 1 to: programState node stop) allRangesOfSubstring: '_echo') size * 5.	
	start := programState node start - sourceDelta.
	stop := programState node stop - sourceDelta + 1.

	(nodeSource includesSubstring: '_echo') ifTrue: [
		| interval |
		interval := (code text allRangesOfSubstring:
			             (self printStringWithoutEcho: nodeSource)) last.
		start := interval first.
		stop := interval last + 1 ].

	code addTextSegmentDecoration:
		(SpTextPresenterDecorator forHighlight
			 interval: (start to: stop);
			 yourself)
]

{ #category : 'updating' }
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
