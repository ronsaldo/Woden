Class {
	#name : #WDESectorLayer,
	#superclass : #WDELevelElement,
	#instVars : [
		'sector',
		'defaultMinZ',
		'defaultMaxZ',
		'children'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDESectorLayer >> accept: visitor [
	^ visitor visitSectorLayer: self
]

{ #category : #adding }
WDESectorLayer >> addEntity: anEntity [
	self assert: anEntity isEntity.
	self assert: anEntity sectorLayer isNil.
	children add: anEntity.
	anEntity parent: self.
	self level ifNotNil: [ :level | anEntity addedToLevel: level ].
]

{ #category : #accessing }
WDESectorLayer >> children [
	^ children
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createPointEntity: entityClassName at: entityLocation [
	^ self instanceEntityPrototype: WDEEntity pointPrototype withClassName: entityClassName andPlaceAt: entityLocation
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createSolidEntity: entityClassName box: box color: color [
	^ (self instanceEntityPrototype: WDEEntity solidWall3DPrototype withClassName: entityClassName andPlaceInBox: box)
		setVisualColor: color;
		yourself
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createSolidEntity: entityClassName rectangle: rectangle color: color [
	^ (self instanceEntityPrototype: WDEEntity solidWall2DPrototype withClassName: entityClassName andPlaceInRectangle: rectangle)
		setVisualColor: color;
		yourself
]

{ #category : #accessing }
WDESectorLayer >> defaultMaxZ [
	^ defaultMaxZ
]

{ #category : #accessing }
WDESectorLayer >> defaultMaxZ: anObject [
	defaultMaxZ := anObject
]

{ #category : #accessing }
WDESectorLayer >> defaultMinZ [
	^ defaultMinZ
]

{ #category : #accessing }
WDESectorLayer >> defaultMinZ: anObject [
	defaultMinZ := anObject
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> defaultThickness: defaultThickness [
	self
		defaultMinZ: defaultThickness * -0.5;
		defaultMaxZ: defaultThickness * 0.5
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> defaultZ [
	^ defaultMinZ + ((defaultMaxZ  - defaultMinZ) /2)
]

{ #category : #serialization }
WDESectorLayer >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#children . children collect: [ :each | each encodeForJSON ].
	}
]

{ #category : #accessing }
WDESectorLayer >> entities [
	^ children
]

{ #category : #initialization }
WDESectorLayer >> initialize [
	super initialize.
	children := OrderedCollection new.
	defaultMinZ := -1.0.
	defaultMaxZ := -1.0.
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> instanceEntityPrototype: entityPrototype [
	^ entityPrototype copy
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> instanceEntityPrototype: entityPrototype withClassName: newClassName [
	^ entityPrototype copy
		className: newClassName;
		yourself
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> instanceEntityPrototype: prototype withClassName: entityClassName andPlaceAt: entityLocation [
	| entity |
	entity := self instanceEntityPrototype: prototype withClassName: entityClassName.
	entity placeInPosition: entityLocation.
	self addEntity: entity.
	^ entity
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> instanceEntityPrototype: prototype withClassName: entityClassName andPlaceInBox: placementBox [
	| entity |
	entity := self instanceEntityPrototype: prototype withClassName: entityClassName.
	entity placeInBox: placementBox.
	self addEntity: entity.
	^ entity
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> instanceEntityPrototype: prototype withClassName: entityClassName andPlaceInRectangle: placementRectangle [
	| entity |
	entity := self instanceEntityPrototype: prototype withClassName: entityClassName.
	entity placeInRectangle: placementRectangle.
	self addEntity: entity.
	^ entity
]

{ #category : #testing }
WDESectorLayer >> isInSector2D [
	^ sector isSector2D
]

{ #category : #testing }
WDESectorLayer >> isSectorLayer [
	^ true
]

{ #category : #serialization }
WDESectorLayer >> loadFromJson: jsonData [
	super loadFromJson: jsonData.
	self
		defaultMinZ: (jsonData at: 'defaultMinZ' ifAbsent: [-1.0]);
		defaultMaxZ: (jsonData at: 'defaultMaxZ' ifAbsent: [1.0]).

	jsonData at: 'children' ifPresent: [ :childrenData |
		childrenData do: [ :each |
			self addEntity: (WDELevelElement loadFromJson: each)
		]
	]
]

{ #category : #accessing }
WDESectorLayer >> parent [
	^ sector
]

{ #category : #accessing }
WDESectorLayer >> sector [
	^ sector
]

{ #category : #accessing }
WDESectorLayer >> sector: anObject [
	sector := anObject
]

{ #category : #accessing }
WDESectorLayer >> sectorLayer [
	^ self
]