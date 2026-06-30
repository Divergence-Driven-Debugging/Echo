Class {
	#name : 'EchoDebuggerPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'debugger'
	],
	#category : 'Echo-Tests',
	#package : 'Echo-Tests'
}

{ #category : 'helpers' }
EchoDebuggerPresenterTest >> methodSourceExampleWithEchoString [

	^ 'testChildConfigurationLooksUpParentConfiguration
	| c1 c2 |
	c1 := PCBConfig_echo new.
	c1 mySetting: 0.
	c2 := PCBConfig_echo new.
	c2 parentConfig: c1.
	c2 mySetting	'
]

{ #category : 'helpers' }
EchoDebuggerPresenterTest >> methodSourceExampleWithoutEchoString [

	^ 'testChildConfigurationLooksUpParentConfiguration
	| c1 c2 |
	c1 := PCBConfig new.
	c1 mySetting: 0.
	c2 := PCBConfig new.
	c2 parentConfig: c1.
	c2 mySetting	'
]

{ #category : 'running' }
EchoDebuggerPresenterTest >> setUp [
	super setUp.

	debugger := EchoDebuggerPresenter basicNew
]

{ #category : 'tests' }
EchoDebuggerPresenterTest >> testPrintingWithoutEcho [

	self
		assert:
		(debugger printStringWithoutEcho:
			 'PCB_Test_echo>>someMethodSelector')
		equals: 'PCB_Test>>someMethodSelector'.
	self
		assert: (debugger printStringWithoutEcho:
				 self methodSourceExampleWithEchoString)
		equals: self methodSourceExampleWithoutEchoString
]
