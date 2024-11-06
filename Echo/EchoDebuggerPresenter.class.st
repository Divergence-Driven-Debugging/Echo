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
	newLayout add: (SpBoxLayout newLeftToRight
			 add: self referenceExecutionLayout;
			" add: self divergencesList expand: false;"
			 add: self modifiedExecutionLayout;
			 yourself).
	^ newLayout
]

{ #category : 'layout' }
EchoDebuggerPresenter >> divergencesList [

	divergencesList := self newList.
	^divergencesList 
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
		
	modifiedStack := self newList.	
	modifiedCode := self newCode.
	modifiedCode beNotEditable.
	self initializeEventsBetweenStack: modifiedStack andCode: modifiedCode.
	
	referenceStack := self newList.
	referenceCode := self newCode.
	referenceCode beNotEditable.
	self initializeEventsBetweenStack: referenceStack andCode: referenceCode.
	
	referenceStack items: echo first.
	referenceStack selectFirst.
	modifiedStack items: echo second.
	modifiedStack selectFirst.
	divergencesList items: echo last.
]

{ #category : 'layout' }
EchoDebuggerPresenter >> modifiedExecutionLayout [

	^ SpBoxLayout newTopToBottom
		  add: modifiedStack;
		  add: modifiedCode;
		  yourself
]

{ #category : 'layout' }
EchoDebuggerPresenter >> referenceExecutionLayout [

	^ SpBoxLayout newTopToBottom
		  add: referenceStack;
		  add: referenceCode;
		  yourself
]

{ #category : 'initialize' }
EchoDebuggerPresenter >> setModelBeforeInitialization: anEchoDebuggingResult [
	echo := anEchoDebuggingResult
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
