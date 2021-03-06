Class {
	#name : #RWElementTest,
	#superclass : #RWTest,
	#instVars : [
		'element',
		'shape'
	],
	#category : #'WodenEngine-Roassal-Tests'
}

{ #category : #tests }
RWElementTest >> setUp [
	super setUp.
	shape := RWCube new.
	element := shape elementOn: 20.

]

{ #category : #tests }
RWElementTest >> testBasic [	
	self assert: element model equals: 20.
	self assert: element shape equals: shape
]

{ #category : #test }
RWElementTest >> testBottomAnchorPoint [
	| anchor |
	anchor := element bottomAnchorPoint.
	self assert: anchor element equals: element.
	self assert: anchor position closeTo: (element position - (Float32x3 y: 0.5)).
]

{ #category : #test }
RWElementTest >> testCenterAnchorPoint [
	| anchor |
	anchor := element centerAnchorPoint.
	self assert: anchor element equals: element.
	self assert: anchor position equals: element position.
]

{ #category : #'test connected edges' }
RWElementTest >> testConnectedEdges01 [

	| e1 e2 l |
	e1 := RWCube element.
	e2 := RWCube element.
	self deny: (e1 isConnectedTo: e2).
	self deny: (e2 isConnectedTo: e1).
	
	l := RWLine edgeFrom: e1 to: e2.
	self assert: (e1 isConnectedTo: e2).
	self assert: (e2 isConnectedTo: e1).

	self assert: (e1 isDirectlyConnectedTo: e2).
	self deny: (e2 isDirectlyConnectedTo: e1).

]

{ #category : #'test connected edges' }
RWElementTest >> testConnectedEdgesBasic [

	self assert: RWCube element connectedEdges isEmpty
]

{ #category : #tests }
RWElementTest >> testDefaultOrientationMatrix [

	self assert: element orientationMatrix equals: Float32x3x3 identity.
]

{ #category : #tests }
RWElementTest >> testGrowingCubes [

	| v es |
	v := RWView new.
	shape := RWCube new size: #yourself.
	es := shape elementsOn: (1 to: 3 by: 0.5).
	v addAll: es. 
	
	"We cannot test much because Renderable does not have bounding box"
	self assert: (es first boundingBox extent closeTo: (Float32x3 x: 1.0 y: 1.0 z: 1.0))
]

{ #category : #tests }
RWElementTest >> testIsInView [

	| e v |
	e := RWElement new.
	self assert: e view isNil.
	
	v := RWView new.
	v add: e.
	self assert: e view equals: v
]

{ #category : #tests }
RWElementTest >> testLookDown [

	self assert: element orientationMatrix equals: Float32x3x3 identity.
	element lookDown.
	self assert: (element orientationMatrix thirdRow closeTo: (Float32x3 x: 0.0 y: -1.0 z: 0.0))
]

{ #category : #tests }
RWElementTest >> testPosition [

	self assert: element position equals: Float32x3 new.
	
	element translateToX: 1.0 y: 2.0 z: 3.0.
	self assert: element position equals: (Float32x3 x: 1.0 y: 2.0 z: 3.0).
]

{ #category : #tests }
RWElementTest >> testReplaceSceneNode [
	| newNode |
	newNode := WDSGLocalShapedSpatialInstanceObject new.
	self assert: element sceneNode ~~ newNode.
	element replaceSceneNode: newNode.
	self assert: element sceneNode == newNode.

]

{ #category : #tests }
RWElementTest >> testRotateByX [
	| angle matrix |
	angle := 60 degreesToRadians.
	matrix := Float32x3x3 xRotation: angle.
	element rotateByX: angle.
	self assert: (element orientationMatrix closeTo: matrix)
]

{ #category : #tests }
RWElementTest >> testRotateByXDegrees [
	| angle matrix |
	angle := 60.
	matrix := Float32x3x3 xRotation: angle degreesToRadians.
	element rotateByXDegrees: angle.
	self assert: (element orientationMatrix closeTo: matrix)
]

{ #category : #tests }
RWElementTest >> testRotateByY [
	| angle matrix |
	angle := 60 degreesToRadians.
	matrix := Float32x3x3 yrot: angle.
	element rotateByY: angle.
	self assert: (element orientationMatrix closeTo: matrix)
]

{ #category : #tests }
RWElementTest >> testRotateByYDegrees [
	| angle matrix |
	angle := 60.
	matrix := Float32x3x3 yrot: angle degreesToRadians.
	element rotateByYDegrees: angle.
	self assert: (element orientationMatrix closeTo: matrix)
]

{ #category : #tests }
RWElementTest >> testRotateByZ [
	| angle matrix |
	angle := 60 degreesToRadians.
	matrix := Float32x3x3 zRotation: angle.
	element rotateByZ: angle.
	self assert: (element orientationMatrix closeTo: matrix)
]

{ #category : #tests }
RWElementTest >> testRotateByZDegrees [
	| angle matrix |
	angle := 60.
	matrix := Float32x3x3 zRotation: angle degreesToRadians.
	element rotateByZDegrees: angle.
	self assert: (element orientationMatrix closeTo: matrix)
]

{ #category : #tests }
RWElementTest >> testShapeSize [

	| el |
	shape := RWCube new 
					width: [ :e | e + 1 ];
					height: [ :e | e + 2 ];
					depth: [ :e | e + 3 ].
					
	el := shape elementOn: 5.

	self assert: el extent = (Float32x3 x: 6.0 y: 7.0 z: 8.0)
]

{ #category : #test }
RWElementTest >> testTopAnchorPoint [
	| anchor |
	anchor := element topAnchorPoint.
	self assert: anchor element equals: element.
	self assert: anchor position closeTo: (element position + (Float32x3 y: 0.5)).
]

{ #category : #tests }
RWElementTest >> testTranslateBy [

	self assert: element position equals: Float32x3 new.
		
	element translateBy: (Float32x3 x: 1.0 y: 2.0 z: 3.0).
	self assert: element position equals: (Float32x3 x: 1.0 y: 2.0 z: 3.0).
]

{ #category : #tests }
RWElementTest >> testTranslateByX [

	self assert: element position equals: Float32x3 zeros.
		
	element translateByX: 2.0.
	self assert: element position equals: (Float32x3 x: 2.0 y: 0.0 z: 0.0).
]

{ #category : #tests }
RWElementTest >> testTranslateByXYZ [

	self assert: element position equals: Float32x3 zeros.
		
	element translateByX: 1.0 y: 2.0 z: 3.0.
	self assert: element position equals: (Float32x3 x: 1.0 y: 2.0 z: 3.0).
]

{ #category : #tests }
RWElementTest >> testTranslateByY [

	self assert: element position equals: Float32x3 zeros.
		
	element translateByY: 2.0.
	self assert: element position equals: (Float32x3 x: 0.0 y: 2.0 z: 0.0).
]

{ #category : #tests }
RWElementTest >> testTranslateByZ [

	self assert: element position equals: Float32x3 zeros.
		
	element translateByZ: 2.0.
	self assert: element position equals: (Float32x3 x: 0.0 y: 0.0 z: 2.0).
]

{ #category : #tests }
RWElementTest >> testTranslateTo [

	self assert: element position equals: Float32x3 zeros.
	element translateToX: 1.0 y: 2.0 z: 3.0.
	self assert: element position equals: (Float32x3 x: 1.0 y: 2.0 z: 3.0).
]

{ #category : #tests }
RWElementTest >> testTranslateToX [

	self assert: element position equals: Float32x3 zeros.
		
	element translateToX: 5.0.
	self assert: element position equals: (Float32x3 x: 5.0 y: 0.0 z: 0.0).
]

{ #category : #tests }
RWElementTest >> testTranslateToY [

	self assert: element position equals: Float32x3 zeros.
		
	element translateToY: 2.0.
	self assert: element position equals: (Float32x3 x: 0.0 y: 2.0 z: 0.0).
]

{ #category : #tests }
RWElementTest >> testTranslateToZ [

	self assert: element position equals: Float32x3 zeros.
		
	element translateToZ: -3.0.
	self assert: element position equals: (Float32x3 x: 0.0 y: 0.0 z: -3.0).
]
