Class {
	#name : 'QueryLinePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'query'
	],
	#category : 'Echo-Presenters',
	#package : 'Echo',
	#tag : 'Presenters'
}

{ #category : 'initialization' }
QueryLinePresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		  add: self newPropertyDropList;
		  yourself
]

{ #category : 'initialization' }
QueryLinePresenter >> initializePresenters [

	query := EchoQuery new.
	model addQuery: query.
]

{ #category : 'instance creation' }
QueryLinePresenter >> newPropertyDropList [


	| sortedProperties |
    sortedProperties := model availableProperties sorted:
                            #asString ascending.

    ^ self newDropList
          startWithoutSelection;
          items: sortedProperties;
          display: [ :prop | prop asString ];
          whenSelectedItemChangedDo: [ :property | 
              query updateType: property ];
          yourself
]

{ #category : 'accessing - model' }
QueryLinePresenter >> setModelBeforeInitialization: anEchoDebuggingResult [

	model := anEchoDebuggingResult
]
