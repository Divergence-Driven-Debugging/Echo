Extension { #name : 'Object' }

{ #category : '*Echo' }
Object >> package [

 ^ self class package 
]

{ #category : '*Echo' }
Object >> slotsValue [

	| slotValue |
	slotValue := Dictionary new.
	self class slots do: [ :s | slotValue at: s put: (self readSlot: s) ].
	^ slotValue
]
