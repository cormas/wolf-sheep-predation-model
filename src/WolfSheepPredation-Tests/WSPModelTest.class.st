"
I check the rules of the Wolf Sheep Predation model on a small grid of 3 × 3 patches: what wolves and sheep eat, when they die, how they reproduce, how grass grows again, and how sheep avoid crowds in version 3.
"
Class {
	#name : 'WSPModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'model',
		'center'
	],
	#category : 'WolfSheepPredation-Tests',
	#package : 'WolfSheepPredation-Tests'
}

{ #category : 'running' }
WSPModelTest >> fillNeighboursOf: aPatch except: aCollection [

	aPatch neighbourhood do: [ :each |
			(aCollection includes: each) ifFalse: [
				self newSheepWithEnergy: 1 on: each ] ]
]

{ #category : 'running' }
WSPModelTest >> newSheepWithEnergy: aNumber on: aPatch [

	^ (model newEntity: WSPSheep)
		  energy: aNumber;
		  moveTo: aPatch;
		  yourself
]

{ #category : 'running' }
WSPModelTest >> newWolfWithEnergy: aNumber on: aPatch [

	^ (model newEntity: WSPWolf)
		  energy: aNumber;
		  moveTo: aPatch;
		  yourself
]

{ #category : 'running' }
WSPModelTest >> setUp [

	super setUp.
	model := WSPModel new.
	model
		createGridNumberOfRows: 3
		numberOfColumns: 3
		neighbourhood: 8
		closed: false.
	model cells do: [ :each | each growGrass ].
	model sheepReproductionRate: 0.
	model wolfReproductionRate: 0.
	center := model cellAt: 2 at: 2
]

{ #category : 'tests' }
WSPModelTest >> testASheepOnGreenGrassEatsIt [

	| sheep |
	sheep := self newSheepWithEnergy: 3 on: center.
	sheep eatGrass.
	self deny: center hasGrass.
	self assert: sheep energy equals: 3 + model sheepGainFromFood
]

{ #category : 'tests' }
WSPModelTest >> testAWolfEatsASheepOnItsPatchAndGainsEnergy [

	| wolf sheep |
	wolf := self newWolfWithEnergy: 5 on: center.
	sheep := self newSheepWithEnergy: 1 on: center.
	wolf eatSheep.
	self assert: sheep isDead.
	self assert: wolf energy equals: 5 + model wolfGainFromFood
]

{ #category : 'tests' }
WSPModelTest >> testAWolfWhoseEnergyReachesZeroDies [

	| wolf |
	wolf := self newWolfWithEnergy: model wolfMoveCost on: center.
	wolf step.
	self assert: wolf isDead
]

{ #category : 'tests' }
WSPModelTest >> testAnAnimalThatReproducesSharesItsEnergyWithItsOffspring [

	| sheep offspring |
	model sheepReproductionRate: 1.
	sheep := self newSheepWithEnergy: 8 on: center.
	sheep reproduce.
	offspring := (model @@ WSPSheep) detect: [ :each | each ~~ sheep ].
	self assert: sheep energy equals: 4.
	self assert: offspring energy equals: 4.
	self assert: (center neighbourhood includes: offspring cell)
]

{ #category : 'tests' }
WSPModelTest >> testAnEatenPatchGrowsGrassAgainAfterTheRegrowthTime [

	model grassRegrowthTime: 3.
	center beEaten.
	2 timesRepeat: [ center step ].
	self deny: center hasGrass.
	center step.
	self assert: center hasGrass
]

{ #category : 'tests' }
WSPModelTest >> testWithCrowdingASheepMovesOnlyOntoAFreePatch [

	| sheep free |
	free := model cellAt: 1 at: 1.
	sheep := self newSheepWithEnergy: 1 on: center.
	self fillNeighboursOf: center except: { free }.
	sheep stepAvoidingCrowds.
	self assert: sheep cell equals: free
]

{ #category : 'tests' }
WSPModelTest >> testWithCrowdingASheepWithNoFreePatchAroundStaysAndDoesNotReproduce [

	| sheep |
	model sheepReproductionRate: 1.
	sheep := self newSheepWithEnergy: 1 on: center.
	self fillNeighboursOf: center except: #(  ).
	sheep stepAvoidingCrowds.
	self assert: sheep cell equals: center.
	self assert: (model @@ WSPSheep) size equals: 9
]

{ #category : 'tests' }
WSPModelTest >> testWithGrassASheepWithNoEnergyLeftDies [

	| sheep |
	model cells do: [ :each | each beEaten ].
	sheep := self newSheepWithEnergy: 0 on: center.
	sheep stepEatingGrass.
	self assert: sheep isDead
]

{ #category : 'tests' }
WSPModelTest >> testWithoutGrassSheepNeverLoseEnergy [

	| sheep |
	sheep := self newSheepWithEnergy: 0 on: center.
	10 timesRepeat: [ sheep step ].
	self deny: sheep isDead.
	self assert: sheep energy equals: 0
]
