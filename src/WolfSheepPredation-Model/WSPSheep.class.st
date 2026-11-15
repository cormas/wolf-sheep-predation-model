"
I am a sheep. I move, eat grass in the version with grass, reproduce, and die when a wolf eats me or, in the version with grass, when my energy is below 0.

## Responsibility:

- Act as in each version of the paper: `step` (version 1), `stepEatingGrass` (version 2), `stepAvoidingCrowds` (version 3, where I only move to and give birth on an unoccupied patch).
- Eat the grass of my patch.

## Collaborators:

- `WSPPatch`: the grass I eat.
- `WSPWolf`: eats me.

## Public API and Key Messages

- `step`, `stepEatingGrass`, `stepAvoidingCrowds`, `eatGrass`.
"
Class {
	#name : 'WSPSheep',
	#superclass : 'WSPAnimal',
	#category : 'WolfSheepPredation-Model',
	#package : 'WolfSheepPredation-Model'
}

{ #category : 'aspects' }
WSPSheep >> aspectDefault: look [

	<aspect>
	look
		color: CMColor white;
		size: 0.6
]

{ #category : 'biology' }
WSPSheep >> eatGrass [

	<action>
	self cell hasGrass ifFalse: [ ^ self ].
	self cell beEaten.
	energy := energy + self gainFromFood
]

{ #category : 'accessing' }
WSPSheep >> gainFromFood [

	^ self cormasModel sheepGainFromFood
]

{ #category : 'accessing' }
WSPSheep >> moveCost [

	^ self cormasModel sheepMoveCost
]

{ #category : 'accessing' }
WSPSheep >> reproductionRate [

	^ self cormasModel sheepReproductionRate
]

{ #category : 'biology' }
WSPSheep >> step [
	"Version 1 of the paper: move to an adjacent patch and reproduce. Sheep have no use for energy, and die only when eaten"

	<action>
	self
		move;
		reproduce
]

{ #category : 'biology' }
WSPSheep >> stepAvoidingCrowds [
	"Version 3 of the paper: move only to an unoccupied adjacent patch, or stay, and reproduce only if an adjacent patch is unoccupied"

	<action>
	| freePatches |
	self randomWalkConstrainedBy: [ :each | each hasNoOccupants ].
	freePatches := self cell neighbourhood select: [ :each |
		               each hasNoOccupants ].
	(freePatches isNotEmpty and: [ self random < self reproductionRate ])
		ifTrue: [ self giveBirthOn: (self selectRandomlyFrom: freePatches) ]
]

{ #category : 'biology' }
WSPSheep >> stepEatingGrass [
	"Version 2 of the paper: move at a cost, eat the grass of my patch, die when my energy is below 0, and reproduce"

	<action>
	self
		move;
		loseEnergy;
		eatGrass.
	energy < 0 ifTrue: [ ^ self die ].
	self reproduce
]
