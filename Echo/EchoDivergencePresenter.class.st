Class {
	#name : 'EchoDivergencePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'divergenceTable',
		'divergenceLabel',
		'referenceStack',
		'modifiedStack',
		'referenceCode',
		'modifiedCode'
	],
	#category : 'Echo-Presenters',
	#package : 'Echo',
	#tag : 'Presenters'
}

{ #category : 'layout' }
EchoDivergencePresenter >> defaultLayout [

	 ^ SpBoxLayout newTopToBottom
		   add: divergenceTable;
		   add: divergenceLabel expand: false;
			add: (SpBoxLayout newHorizontal spacing: 5;
				borderWidth: 5 ;
				add: referenceStack ;
				add: modifiedStack ;
				yourself);
			add: (SpBoxLayout newHorizontal spacing: 5;
				borderWidth: 5 ;
				add: referenceCode ;
				add: modifiedCode ;
				yourself);
		   yourself
]

{ #category : 'initialization' }
EchoDivergencePresenter >> initializeCodePresenter [

	referenceCode := self newCode.
	referenceCode beNotEditable.
	

	modifiedCode := self newCode.
	modifiedCode beNotEditable.
]

{ #category : 'initialization' }
EchoDivergencePresenter >> initializeDivergenceTable [

	 "divergenceTable := self newTable."
	 divergenceLabel := self newLabel.


	 "divergenceTable
		 addColumn: ((SpImageTableColumn
				   title: 'Type'
				   evaluated: [ :elem | elem icon ])
				  width: 50;
				  yourself);
		 addColumn: (SpStringTableColumn title: 'description' evaluated: #description);
		 items: model divergences;
		 beResizable."
		
	
	




	divergenceTable := self newTreeTable.
	divergenceTable	addColumn: ((SpImageTableColumn
				   title: 'Type'
				   evaluated: [ :elem | elem icon ])
				  width: 50;
				  yourself);
			addColumn: (SpStringTableColumn evaluated: #description);
		roots: model headDivergence ;
		children: [ :div | div linkedDivergence ];
		beResizable.
		
	
self updateStackFromDivergenceEvent.
]

{ #category : 'initialization' }
EchoDivergencePresenter >> initializeEventsBetweenStackAndCode [

	 referenceStack transmitDo: [ :t |
		 t ifNotNil: [ self updateCode: referenceCode with: t ] ].
	 modifiedStack transmitDo: [ :t |
		 t ifNotNil: [ self updateCode: modifiedCode with: t ] ]
]

{ #category : 'initialization' }
EchoDivergencePresenter >> initializePresenters [


	"self initializeToolBar."
	self initializeDivergenceTable.
	"self initializeTTQPresenter."
	self initializeStackTable.
	self initializeCodePresenter.
	self initializeEventsBetweenStackAndCode "
	self initializeInspectorPresenter."
	
]

{ #category : 'initialization' }
EchoDivergencePresenter >> initializeStackTable [

	 referenceStack := self newTable
		                   addColumn:
			                   (SpStringTableColumn
				                    title: 'reference stack'
				                    evaluated: #fullPrintString);
		                   items: model referenceStack;
		                   selectFirst;
		                   yourself.




	 modifiedStack := self newTable
		                   addColumn:
			                   (SpStringTableColumn
				                    title: 'modified stack'
				                    evaluated: #fullPrintString);
		                   items: model modifiedStack;
		                   selectFirst;
		                   yourself.
]

{ #category : 'initialization' }
EchoDivergencePresenter >> setModelBeforeInitialization: aModel [

	model := aModel 
]

{ #category : 'TOREMOVE' }
EchoDivergencePresenter >> title [

	^ String streamContents: [ :str |
		  str << model divergences size asString.
		  str space.
		  str << 'divergences detected' ]
]

{ #category : 'updating - presenters' }
EchoDivergencePresenter >> updateCode: code with: trace [

	 model updateCode: code with: trace.

	 
]

{ #category : 'initialization' }
EchoDivergencePresenter >> updateStackFromDivergenceEvent [


	 divergenceTable transmitDo: [ :div |
		 model updateReferenceStack: referenceStack whiteDiv: div.
		 model updateModifiedStack: modifiedStack whiteDiv: div ]
]
