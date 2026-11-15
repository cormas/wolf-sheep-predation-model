Class {
	#name : 'BaselineOfWolfSheepPredation',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfWolfSheepPredation',
	#package : 'BaselineOfWolfSheepPredation'
}

{ #category : 'baselines' }
BaselineOfWolfSheepPredation >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec
			package: 'WolfSheepPredation-Model';
			package: 'WolfSheepPredation-Tests' with: [ spec requires: #( 'WolfSheepPredation-Model' ) ] ]
]

{ #category : 'baselines' }
BaselineOfWolfSheepPredation >> isManagedByCormas [
	"Cormas wrote this baseline and keeps it up to date when packages of the model are added, renamed or removed. If you change the baseline yourself, Cormas asks whether you want to manage it yourself: this method then returns false, and Cormas never changes the baseline again"

	^ true
]
