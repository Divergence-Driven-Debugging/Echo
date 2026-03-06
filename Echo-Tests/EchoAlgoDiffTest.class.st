Class {
	#name : 'EchoAlgoDiffTest',
	#superclass : 'TestCase',
	#category : 'Echo-Tests-Core',
	#package : 'Echo-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
EchoAlgoDiffTest >> testDivergenceOnFlow [

| echo  analyseDiv recorder result |
	echo := Echo new.
	analyseDiv := EchoAnalyse new.

	echo original: [Candy new sugar ].
	echo modified: [Candy new chocolat ].
	recorder := SCOPEOTraceRecorder
		             original: echo original
		             modified: echo modified.
	recorder execute.

	analyseDiv := EchoAnalyse new.
	result := analyseDiv analyseDiv: recorder.
	
	self assert: result flowDivergences size equals: 1 .
	
	
	
]

{ #category : 'tests' }
EchoAlgoDiffTest >> testDivergenceOnFlowArguments [

| echo  analyseDiv recorder result |
	echo := Echo new.
	analyseDiv := EchoAnalyse new.

	echo original: [Candy new cacao:3 ].
	echo modified: [Candy new cacao:4 ].
	recorder := SCOPEOTraceRecorder
		             original: echo original
		             modified: echo modified.
	recorder execute.
	1halt.

	analyseDiv := EchoAnalyse new.
	result := analyseDiv analyseDiv: recorder.
	
	self assert: result flowDivergences size equals: 1 .
	
	
	
]

{ #category : 'tests' }
EchoAlgoDiffTest >> testDivergenceOnFlowandAssignement [

| echo  analyseDiv recorder result |
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
	
	self assert: result flowDivergences size equals: 1 .
	self assert: result assignementDivergences size equals: 1 .

	
]

{ #category : 'tests' }
EchoAlgoDiffTest >> testDivergenceOneAssignementDivergeFlowAndValue [

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
	
	self assert:( result assignementDivergences select: [:e |e state]) size equals: 0.
	self assert:( result assignementDivergences select: [:e |e flow]) size equals: 0.
	
	
]

{ #category : 'tests' }
EchoAlgoDiffTest >> testDivergenceOneAssignementDivergeOnValue [

| echo analyseDiv recorder result |
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
	
	self assert:( result assignementDivergences select: [:e |e state]) size equals: 0.
	
	
	
]

{ #category : 'tests' }
EchoAlgoDiffTest >> testDivergenceOneAssignementNoDiverge [

| echo  analyseDiv recorder result |
	echo := Echo new.
	analyseDiv := EchoAnalyse new.

	echo original: [Candy new sugar].
	echo modified: [Candy new sugar ].
	recorder := SCOPEOTraceRecorder
		             original: echo original
		             modified: echo modified.
	recorder execute.
	
	analyseDiv := EchoAnalyse new.
	result := analyseDiv analyseDiv: recorder.
	
	self assert: result assignementDivergences size equals: 0 .
	
	
	
]
