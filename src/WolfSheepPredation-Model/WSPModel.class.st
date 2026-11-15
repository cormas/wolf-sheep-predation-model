"
I am the Wolf Sheep Predation model of Wilensky and Reisman (2006): wolves eat sheep, sheep eat grass, and both reproduce, which makes their populations oscillate or go extinct.

Source: Wilensky, U. & Reisman, K. (2006). Thinking like a wolf, a sheep or a firefly: Learning biology through constructing and testing computational theories — an embodied modeling approach. Cognition and Instruction, 24(2), 171–209. The paper is the reference for the rules. Where it says nothing, the choices of NetLogo's Wolf Sheep Predation model (Wilensky, 1997) are used, and marked as such.

## Responsibility:

- Create the patches and the animals of one of the three versions of the paper: `sheepWolves`, `sheepWolvesGrass` and `sheepWolvesCrowding`.
- Run each step of that version: all sheep in a random order, then all wolves in a random order, then the grass in the version with grass.
- Count the sheep, the wolves and the patches with grass, as probes.

## Collaborators:

- `WSPPatch`: the patches of the paper, with or without grass.
- `WSPSheep` and `WSPWolf`: the animals, which follow the rules of the paper.

## Public API and Key Messages

- Init methods: `sheepWolves`, `sheepWolvesGrass`, `sheepWolvesCrowding`. Control methods: `stepSheepWolves`, `stepSheepWolvesGrass`, `stepSheepWolvesCrowding`.
- Probes: `numberOfSheep`, `numberOfWolves`, `amountOfGrass`. Stop condition: `noAnimalIsLeft`.

```
(CMSimulation for: WSPModel new)
	activeInitSelector: #sheepWolvesGrass;
	activeControlSelector: #stepSheepWolvesGrass;
	initializeSimulation;
	runStep
```

## Internal Representation

The parameters, with the names of the paper in brackets: `initialNumberOfSheep`, `initialNumberOfWolves`, `sheepGainFromFood` (E4), `wolfGainFromFood` (E2), `sheepMoveCost` (E3), `wolfMoveCost` (E1), `sheepReproductionRate` and `wolfReproductionRate` (R2 and R1), `grassRegrowthTime` (X1), `numberOfRows` and `numberOfColumns`.

### Implementation Points

- From NetLogo's model, where the paper is silent: the default values of the parameters, the 51 × 51 world that wraps around, the random energy of animals at the start, a parent sharing its energy with its offspring, half the patches starting without grass, and the order within a step.
- From the paper, where NetLogo differs: animals move to an adjacent patch (Cormas' `randomWalk`, where NetLogo turns a little and moves forward), wolves die when their energy reaches 0, moving has its own cost, and a patch grows grass again exactly `grassRegrowthTime` steps after it was eaten.
- Because animals move to a random adjacent patch at each step, they spread more slowly than in NetLogo. In the version with grass, both species survive, but wolves stay few and the populations oscillate much less than in NetLogo.
"
Class {
	#name : 'WSPModel',
	#superclass : 'CMModel',
	#instVars : [
		'numberOfRows',
		'numberOfColumns',
		'initialNumberOfSheep',
		'initialNumberOfWolves',
		'sheepGainFromFood',
		'wolfGainFromFood',
		'sheepMoveCost',
		'wolfMoveCost',
		'sheepReproductionRate',
		'wolfReproductionRate',
		'grassRegrowthTime'
	],
	#category : 'WolfSheepPredation-Model',
	#package : 'WolfSheepPredation-Model'
}

{ #category : 'accessing' }
WSPModel class >> prefix [
	"Every class name in the model package begins with this prefix"

	^ 'WSP'
]

{ #category : 'probes' }
WSPModel >> amountOfGrass [
	"The number of patches with grass"

	<probeNamed: 'Grass' color: '00AA00'>
	^ self cells count: [ :each | each hasGrass ]
]

{ #category : 'init' }
WSPModel >> createAnimals [

	self
		 create: initialNumberOfSheep
		 randomlyLocatedEntitiesOfClass: WSPSheep.
	self
		 create: initialNumberOfWolves
		 randomlyLocatedEntitiesOfClass: WSPWolf
]

{ #category : 'init' }
WSPModel >> createPatches [

	self
		createGridNumberOfRows: numberOfRows
		numberOfColumns: numberOfColumns
		neighbourhood: 8
		closed: false
]

{ #category : 'parameters' }
WSPModel >> grassRegrowthTime [
	"The number of steps an eaten patch waits before its grass grows again"

	<parameterIntegerMin: 0 max: 100 default: 30>
	^ grassRegrowthTime
]

{ #category : 'parameters' }
WSPModel >> grassRegrowthTime: anInteger [

	<parameterSetter>
	grassRegrowthTime := anInteger
]

{ #category : 'parameters' }
WSPModel >> initialNumberOfSheep [

	<parameterIntegerMin: 0 max: 250 default: 100>
	^ initialNumberOfSheep
]

{ #category : 'parameters' }
WSPModel >> initialNumberOfSheep: anInteger [

	<parameterSetter>
	initialNumberOfSheep := anInteger
]

{ #category : 'parameters' }
WSPModel >> initialNumberOfWolves [

	<parameterIntegerMin: 0 max: 250 default: 50>
	^ initialNumberOfWolves
]

{ #category : 'parameters' }
WSPModel >> initialNumberOfWolves: anInteger [

	<parameterSetter>
	initialNumberOfWolves := anInteger
]

{ #category : 'testing' }
WSPModel >> noAnimalIsLeft [

	<boolean>
	^ (self @@ WSPAnimal) isEmpty
]

{ #category : 'parameters' }
WSPModel >> numberOfColumns [

	<parameterIntegerMin: 1 max: 200 default: 51>
	^ numberOfColumns
]

{ #category : 'parameters' }
WSPModel >> numberOfColumns: anInteger [

	<parameterSetter>
	numberOfColumns := anInteger
]

{ #category : 'parameters' }
WSPModel >> numberOfRows [

	<parameterIntegerMin: 1 max: 200 default: 51>
	^ numberOfRows
]

{ #category : 'parameters' }
WSPModel >> numberOfRows: anInteger [

	<parameterSetter>
	numberOfRows := anInteger
]

{ #category : 'probes' }
WSPModel >> numberOfSheep [

	<probeNamed: 'Sheep' color: '0000FF'>
	^ (self @@ WSPSheep) size
]

{ #category : 'probes' }
WSPModel >> numberOfWolves [

	<probeNamed: 'Wolves' color: 'FF0000'>
	^ (self @@ WSPWolf) size
]

{ #category : 'parameters' }
WSPModel >> sheepGainFromFood [
	"The energy a sheep gets from the grass of a patch"

	<parameterIntegerMin: 0 max: 50 default: 4>
	^ sheepGainFromFood
]

{ #category : 'parameters' }
WSPModel >> sheepGainFromFood: anInteger [

	<parameterSetter>
	sheepGainFromFood := anInteger
]

{ #category : 'parameters' }
WSPModel >> sheepMoveCost [
	"The energy a sheep loses at each move, in the version with grass"

	<parameterIntegerMin: 0 max: 10 default: 1>
	^ sheepMoveCost
]

{ #category : 'parameters' }
WSPModel >> sheepMoveCost: anInteger [

	<parameterSetter>
	sheepMoveCost := anInteger
]

{ #category : 'parameters' }
WSPModel >> sheepReproductionRate [
	"The probability that a sheep reproduces at each step"

	<parameterFloatMin: 0 max: 1 default: 0.04>
	^ sheepReproductionRate
]

{ #category : 'parameters' }
WSPModel >> sheepReproductionRate: aNumber [

	<parameterSetter>
	sheepReproductionRate := aNumber
]

{ #category : 'init' }
WSPModel >> sheepWolves [
	"Version 1 of the paper: wolves and sheep, on patches that sheep do not eat"

	<init>
	self
		createPatches;
		createAnimals
]

{ #category : 'init' }
WSPModel >> sheepWolvesCrowding [
	"Version 3 of the paper: as version 1, but sheep avoid occupied patches"

	<init>
	self
		createPatches;
		createAnimals
]

{ #category : 'init' }
WSPModel >> sheepWolvesGrass [
	"Version 2 of the paper: sheep eat grass, which grows again. Half the patches start without grass, as in NetLogo's model"

	<init>
	self createPatches.
	self cells do: [ :each |
		self random < 0.5 ifTrue: [ each beEatenSomeTimeAgo ] ].
	self createAnimals
]

{ #category : 'control' }
WSPModel >> stepSheepWolves [
	"All sheep act, then all wolves, each in a random order"

	<control>
	(self shuffled: self @@ WSPSheep) do: [ :each | each step ].
	(self shuffled: self @@ WSPWolf) do: [ :each | each step ]
]

{ #category : 'control' }
WSPModel >> stepSheepWolvesCrowding [
	"All sheep act, avoiding occupied patches, then all wolves, each in a random order"

	<control>
	(self shuffled: self @@ WSPSheep) do: [ :each |
		each stepAvoidingCrowds ].
	(self shuffled: self @@ WSPWolf) do: [ :each | each step ]
]

{ #category : 'control' }
WSPModel >> stepSheepWolvesGrass [
	"All sheep act, then all wolves, each in a random order, then the grass grows"

	<control>
	(self shuffled: self @@ WSPSheep) do: [ :each | each stepEatingGrass ].
	(self shuffled: self @@ WSPWolf) do: [ :each | each step ].
	self cells do: [ :each | each step ]
]

{ #category : 'parameters' }
WSPModel >> wolfGainFromFood [
	"The energy a wolf gets from a sheep"

	<parameterIntegerMin: 0 max: 100 default: 20>
	^ wolfGainFromFood
]

{ #category : 'parameters' }
WSPModel >> wolfGainFromFood: anInteger [

	<parameterSetter>
	wolfGainFromFood := anInteger
]

{ #category : 'parameters' }
WSPModel >> wolfMoveCost [
	"The energy a wolf loses at each move"

	<parameterIntegerMin: 0 max: 10 default: 1>
	^ wolfMoveCost
]

{ #category : 'parameters' }
WSPModel >> wolfMoveCost: anInteger [

	<parameterSetter>
	wolfMoveCost := anInteger
]

{ #category : 'parameters' }
WSPModel >> wolfReproductionRate [
	"The probability that a wolf reproduces at each step"

	<parameterFloatMin: 0 max: 1 default: 0.05>
	^ wolfReproductionRate
]

{ #category : 'parameters' }
WSPModel >> wolfReproductionRate: aNumber [

	<parameterSetter>
	wolfReproductionRate := aNumber
]
