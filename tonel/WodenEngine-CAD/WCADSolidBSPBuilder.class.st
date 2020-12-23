Class {
	#name : #WCADSolidBSPBuilder,
	#superclass : #WCADSolidVisitor,
	#category : #'WodenEngine-CAD-CSG-BSP'
}

{ #category : #visiting }
WCADSolidBSPBuilder >> visitBasicSolid: solid [
	self error: 'Unsupported basic solid for BSP construction.'.
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitBox: box [
	^ (WCADSolidBSPConvexPolyhedron box: box boundingBox) bspTree
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitEllipsoid: ellipsoid [
	^ (WCADSolidBSPConvexPolyhedron cubeEllipsoidWithRadiuses: ellipsoid radiuses subdivisions: ellipsoid subdivisions + 1) bspTree
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitOperation: operation [
	self error: 'Unsupported operation for BSP construction.'.
]

{ #category : #visiting }
WCADSolidBSPBuilder >> visitSphere: sphere [
	^ (WCADSolidBSPConvexPolyhedron icoSphereWithRadius: sphere radius subdivisions: sphere subdivisions) bspTree
]