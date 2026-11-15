"
I am a wolf. In every version of the paper, I move, lose energy, eat a sheep of my patch, die when my energy reaches 0, and reproduce.

## Responsibility:

- Eat one of the sheep on my patch, which gives me energy.
- Die when my energy reaches 0.

## Collaborators:

- `WSPSheep`: what I eat.

## Public API and Key Messages

- `step`, `eatSheep`.
"
Class {
	#name : 'WSPWolf',
	#superclass : 'WSPAnimal',
	#category : 'WolfSheepPredation-Model',
	#package : 'WolfSheepPredation-Model'
}

{ #category : 'aspects' }
WSPWolf >> aspectDefault: look [

	<aspect>
	look
		color: CMColor black;
		size: 0.8
]

{ #category : 'biology' }
WSPWolf >> eatSheep [

	<action>
	| sheep |
	sheep := self cell occupantsOfClass: WSPSheep.
	sheep ifEmpty: [ ^ self ].
	(self selectRandomlyFrom: sheep) die.
	energy := energy + self gainFromFood
]

{ #category : 'accessing' }
WSPWolf >> gainFromFood [

	^ self cormasModel wolfGainFromFood
]

{ #category : 'accessing' }
WSPWolf >> moveCost [

	^ self cormasModel wolfMoveCost
]

{ #category : 'accessing' }
WSPWolf >> reproductionRate [

	^ self cormasModel wolfReproductionRate
]

{ #category : 'biology' }
WSPWolf >> step [
	"The same in the three versions of the paper: move at a cost, eat a sheep of my patch, die when my energy reaches 0, and reproduce"

	<action>
	self
		move;
		loseEnergy;
		eatSheep.
	energy <= 0 ifTrue: [ ^ self die ].
	self reproduce
]
