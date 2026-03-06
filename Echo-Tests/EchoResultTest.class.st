Class {
	#name : 'EchoResultTest',
	#superclass : 'TestCase',
	#instVars : [
		'recorder',
		'result'
	],
	#category : 'Echo-Tests-Core',
	#package : 'Echo-Tests',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
EchoResultTest >> setup1 [

| echo analyseDiv  |
	echo := Echo new.
	analyseDiv := EchoAnalyse new.

	echo original: [Candy new sugar ].
	echo modified: [Candy new sugar1 ].
	recorder := SCOPEOTraceRecorder
		             original: echo original
		             modified: echo modified.
	recorder execute.
	
	analyseDiv := EchoAnalyse new.
	result := analyseDiv analyseDiv: recorder.
	

	
	
]

{ #category : 'as yet unclassified' }
EchoResultTest >> setup2 [

| echo analyseDiv  |
	echo := Echo new.
	analyseDiv := EchoAnalyse new.

	echo original: [Candy new sugar ].
	echo modified: [Candy new sugar ].
	recorder := SCOPEOTraceRecorder
		             original: echo original
		             modified: echo modified.
	recorder execute.
	
	analyseDiv := EchoAnalyse new.
	result := analyseDiv analyseDiv: recorder.
	

	
	
]

{ #category : 'as yet unclassified' }
EchoResultTest >> setup3 [

| echo analyseDiv  |
	echo := Echo new.
	analyseDiv := EchoAnalyse new.

	echo original: [Candy new sugar ].
	echo modified: [Candy new chocoGuimmauve ].
	recorder := SCOPEOTraceRecorder
		             original: echo original
		             modified: echo modified.
	recorder execute.
	
	analyseDiv := EchoAnalyse new.
	result := analyseDiv analyseDiv: recorder.
	

	
	
]

{ #category : 'tests' }
EchoResultTest >> testTTQAssignementDivergences [


 self setup1.
 self assert: result flowDivergences size equals: 1 .
 self assert: result assignementDivergences size equals: 1 .

self halt.

]
