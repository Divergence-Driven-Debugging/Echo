Class {
	#name : 'BaselineOfEcho',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfEcho',
	#package : 'BaselineOfEcho'
}

{ #category : 'baselines' }
BaselineOfEcho >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self dependencies: spec.
		self packages: spec 
	]
]

{ #category : 'baselines' }
BaselineOfEcho >> dependencies: spec [

	spec baseline: 'DeepComparator' with: [
		spec repository: 'github://Modest-Project/DeepComparator:main' 
	].
]

{ #category : 'baselines' }
BaselineOfEcho >> packages: spec [

	spec package: #'Echo'.

]
