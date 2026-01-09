Class {
	#name : 'EchoDivergenceModel',
	#superclass : 'TestCase',
	#category : 'Echo-Tests-Core',
	#package : 'Echo-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
EchoDivergenceModel >> testDivergenceOnAssignementAndFlow [

	| echo analyseDiv recorder result |
	echo := Echo new.
	analyseDiv := EchoAnalyse new.

	echo original: [Candy new sugar ].
	echo modified: [Candy new testwee2 ].
	recorder := SCOPEOTraceRecorder
		             original: echo original
		             modified: echo modified.
	recorder execute.
	
	analyseDiv := EchoAnalyse new.
	result := analyseDiv analyseDiv: recorder.

	

	self assert: result assignementDivergences size equals: 1.
	self deny: result assignementDivergences first state.
	self deny: result assignementDivergences first flow.
]
