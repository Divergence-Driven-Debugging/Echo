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
			 add: self divergencesList expand: false;
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
EchoDebuggerPresenter >> initializePresenters [
	divergencesList := self newList.
		
	modifiedStack := self newList.	
	modifiedCode := self newCode.
	modifiedCode beNotEditable.
	
	referenceStack := self newList.
	referenceCode := self newCode.
	referenceCode beNotEditable.
	
	referenceStack items: echo first.
	modifiedStack items: echo second.
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
