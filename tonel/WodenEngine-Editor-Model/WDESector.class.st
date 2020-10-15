Class {
	#name : #WDESector,
	#superclass : #WDELevelElement,
	#instVars : [
		'level',
		'isSector2D',
		'layers'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDESector >> accept: visitor [
	^ visitor visitSector: self
]

{ #category : #adding }
WDESector >> addLayer: aLayer [
	self assert: aLayer sector isNil.
	layers add: aLayer.
	aLayer sector: self.
	level ifNotNil: [ aLayer addedToLevel: level ].

]

{ #category : #accessing }
WDESector >> children [
	^ layers
]

{ #category : #serialization }
WDESector >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#isSector2D . isSector2D.
		#layers . layers collect: [ :each | each encodeForJSON ].
	}
]

{ #category : #initialization }
WDESector >> initialize [
	super initialize.
	layers := OrderedCollection new.
	isSector2D := false.
]

{ #category : #testing }
WDESector >> isInSector2D [
	^ true
]

{ #category : #testing }
WDESector >> isSector [
	^ true
]

{ #category : #accessing }
WDESector >> isSector2D [
	^ isSector2D
]

{ #category : #accessing }
WDESector >> isSector2D: anObject [
	isSector2D := anObject
]

{ #category : #accessing }
WDESector >> layers [
	^ layers
]

{ #category : #accessing }
WDESector >> level [
	^ level
]

{ #category : #accessing }
WDESector >> level: anObject [
	level := anObject
]

{ #category : #serialization }
WDESector >> loadFromJson: jsonData [
	super loadFromJson: jsonData.
	self isSector2D: (jsonData at: 'isSector2D' ifAbsent: [false]).

	jsonData at: 'layers' ifPresent: [ :childrenData |
		childrenData do: [ :each |
			self addLayer: (WDELevelElement loadFromJson: each)
		]
	]
]

{ #category : #accessing }
WDESector >> parent [
	^ level
]