"
I am a patch of the meadow, the place where sheep and wolves meet. I am a Cormas cell: patch is the word of the paper.

## Responsibility:

- Know whether I have grass, in the version with grass.
- Grow grass again `grassRegrowthTime` steps after I was eaten.

## Collaborators:

- `WSPSheep` eat my grass.
- `WSPModel` gives me the regrowth time, and makes me step.

## Public API and Key Messages

- `hasGrass`, `beEaten`, `step`.

## Internal Representation

- `hasGrass`: whether I have grass (green) or not (brown).
- `countdown`: the steps left before my grass grows again.
"
Class {
	#name : 'WSPPatch',
	#superclass : 'CMCell',
	#instVars : [
		'hasGrass',
		'countdown'
	],
	#category : 'WolfSheepPredation-Model',
	#package : 'WolfSheepPredation-Model'
}

{ #category : 'aspects' }
WSPPatch >> aspectDefault: look [

	<aspect>
	look color: (hasGrass
			 ifTrue: [ CMColor green ]
			 ifFalse: [ CMColor brown ])
]

{ #category : 'grass' }
WSPPatch >> beEaten [
	"Lose my grass, which grows again after the regrowth time of the model"

	hasGrass := false.
	countdown := self cormasModel grassRegrowthTime
]

{ #category : 'grass' }
WSPPatch >> beEatenSomeTimeAgo [
	"Lose my grass, which grows again at a random step within the regrowth time, as if it had been eaten some time ago"

	hasGrass := false.
	countdown := self
		             randomIntegerBetween: 1
		             and: self cormasModel grassRegrowthTime
]

{ #category : 'grass' }
WSPPatch >> growGrass [

	hasGrass := true
]

{ #category : 'grass' }
WSPPatch >> hasGrass [

	^ hasGrass
]

{ #category : 'initialization' }
WSPPatch >> initialize [

	super initialize.
	hasGrass := true.
	countdown := 0
]

{ #category : 'grass' }
WSPPatch >> step [
	"Without grass, wait for the regrowth time, then grow grass again. The paper: 'If brown, then wait X1 clock-ticks and turn green'"

	<action>
	hasGrass ifTrue: [ ^ self ].
	countdown := countdown - 1.
	countdown <= 0 ifTrue: [ self growGrass ]
]
