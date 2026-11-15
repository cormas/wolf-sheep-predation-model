"
I am an animal of the meadow, a sheep or a wolf, with some energy.

## Responsibility:

- Move to a random adjacent patch, as the paper says.
- Lose energy when I move, and reproduce with my reproduction rate, sharing my energy with my offspring.

## Collaborators:

- `WSPModel` gives me my food gain, my move cost and my reproduction rate, through my subclasses.
- `WSPPatch`: where I am, and where my offspring are born.

## Public API and Key Messages

- `energy`, `move`, `loseEnergy`, `reproduce`.

## Internal Representation

- `energy`: a number; sheep only use it in the version with grass.
"
Class {
	#name : 'WSPAnimal',
	#superclass : 'CMAgent',
	#instVars : [
		'energy'
	],
	#category : 'WolfSheepPredation-Model',
	#package : 'WolfSheepPredation-Model'
}

{ #category : 'biology' }
WSPAnimal >> beBornWithRandomEnergy [
	"Start with a random energy below twice my food gain. Not in the paper: taken from NetLogo's model"

	energy := self randomIntegerBetween: 0 and: 2 * self gainFromFood - 1
]

{ #category : 'accessing' }
WSPAnimal >> energy [

	^ energy
]

{ #category : 'accessing' }
WSPAnimal >> energy: aNumber [

	energy := aNumber
]

{ #category : 'accessing' }
WSPAnimal >> gainFromFood [
	"Answer the energy I get from what I eat"

	^ self subclassResponsibility
]

{ #category : 'biology' }
WSPAnimal >> giveBirthOn: aPatch [
	"Share my energy equally with an offspring born on aPatch. Not in the paper: taken from NetLogo's model"

	energy := energy / 2.
	(self cormasModel newEntity: self class)
		energy: energy;
		moveTo: aPatch
]

{ #category : 'initialization' }
WSPAnimal >> initialize [

	super initialize.
	self beBornWithRandomEnergy
]

{ #category : 'biology' }
WSPAnimal >> loseEnergy [

	<action>
	energy := energy - self moveCost
]

{ #category : 'biology' }
WSPAnimal >> move [

	<action>
	self randomWalk
]

{ #category : 'accessing' }
WSPAnimal >> moveCost [
	"Answer the energy I lose at each move"

	^ self subclassResponsibility
]

{ #category : 'biology' }
WSPAnimal >> reproduce [
	"With my reproduction rate, give birth on a neighbouring patch"

	<action>
	self random < self reproductionRate ifTrue: [
		self giveBirthOn: (self selectRandomlyFrom: self cell neighbourhood) ]
]

{ #category : 'accessing' }
WSPAnimal >> reproductionRate [
	"Answer the probability that I reproduce at each step"

	^ self subclassResponsibility
]
