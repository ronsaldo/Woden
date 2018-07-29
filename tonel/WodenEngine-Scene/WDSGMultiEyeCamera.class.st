"
I represent a camera with multiples eyes.
"
Class {
	#name : #WDSGMultiEyeCamera,
	#superclass : #WDSGNode,
	#instVars : [
		'eyes',
		'ipd',
		'focalDistance',
		'projectionMode',
		'vrHeadset',
		'vrTransform'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #'as yet unclassified' }
WDSGMultiEyeCamera class >> single [
	^ self new makeSingle
]

{ #category : #'as yet unclassified' }
WDSGMultiEyeCamera class >> stereo [
	^ self new makeStereo
]

{ #category : #'as yet unclassified' }
WDSGMultiEyeCamera >> addEyes: aCollectionOfEyes [
	eyes := aCollectionOfEyes.
	eyes do: [ :e | self addChild: e ]
]

{ #category : #projections }
WDSGMultiEyeCamera >> applyIPDToEyes [
	self assert: eyes size = 2.
	eyes first transform translation: (WMVector3F x: ipd * -0.5).
	eyes second transform translation: (WMVector3F x: ipd * 0.5)
]

{ #category : #initialization }
WDSGMultiEyeCamera >> initialize [
	super initialize.
	vrTransform := WMReversibleAffineTransformF identity.
]

{ #category : #testing }
WDSGMultiEyeCamera >> isMultiEyeCamera [
	^ true
]

{ #category : #'as yet unclassified' }
WDSGMultiEyeCamera >> makeSingle [
	self addEyes: { WDSGCamera new }
]

{ #category : #'as yet unclassified' }
WDSGMultiEyeCamera >> makeStereo [
	self addEyes: { WDSGCamera new . WDSGCamera new }
]

{ #category : #projections }
WDSGMultiEyeCamera >> reverseDepthPerspectiveFovY: fovy aspect: aspect near: near far: far invertedY: invertedY [
	projectionMode == #stereo ifTrue: [
		^ self stereoReverseDepthPerspectiveFovY: fovy aspect: aspect near: near far: far invertedY: invertedY
	].
	projectionMode == #vr ifTrue: [
		^ self vrReverseDepthPerspectiveNear: near far: far invertedY: invertedY
	].

	eyes do: [ :eye |
		eye reverseDepthPerspectiveFovY: fovy aspect: aspect near: near far: far invertedY: invertedY
	]
]

{ #category : #projections }
WDSGMultiEyeCamera >> stereoIPD: newIPD focalDistance: newFocalDistance [
	ipd := newIPD.
	focalDistance := newFocalDistance.
	projectionMode := #stereo.
	self applyIPDToEyes
]

{ #category : #projections }
WDSGMultiEyeCamera >> stereoReverseDepthPerspectiveFovY: fovy aspect: aspect near: near far: far invertedY: invertedY [
	| leftEye rightEye fovyRad top focalWidth ipd2 focalDistanceFactor |
	leftEye := eyes first.
	rightEye := eyes second.

	fovyRad := fovy degreesToRadians * 0.5.
	top := near * fovyRad tan.
	
	ipd2 := ipd * 0.5.
	focalWidth := aspect * focalDistance * fovyRad tan.
 	focalDistanceFactor := near / focalDistance.
	
	leftEye
		reverseDepthFrustumLeft: focalDistanceFactor * (focalWidth - ipd2) negated
		right: focalDistanceFactor * (focalWidth + ipd2)
		bottom: top negated top: top near: near far: far invertedY: invertedY.
	rightEye 	reverseDepthFrustumLeft: focalDistanceFactor * (focalWidth + ipd2) negated
		right: focalDistanceFactor * (focalWidth - ipd2)
		bottom: top negated top: top near: near far: far invertedY: invertedY.

]

{ #category : #accessing }
WDSGMultiEyeCamera >> updateRenderTransform [
	| localTransform |
	localTransform := transform transformTransform: vrTransform.
	parent ifNotNil: [
		renderTransform := parent renderTransform transformTransform: localTransform.
	] ifNil: [
		renderTransform := localTransform.
	].
]

{ #category : #'as yet unclassified' }
WDSGMultiEyeCamera >> viewportsForRenderTarget: aRenderTarget submode: submode [
	| eyeHeight eyeWidth |
	eyeHeight := aRenderTarget screenExtent y.
	eyeWidth := aRenderTarget screenExtent x // eyes size.
	
	^ eyes collectWithIndex: [ :eye :index |
		eye viewportForRenderTarget: aRenderTarget
			bounds: (((index - 1) * eyeWidth)@0 extent: eyeWidth @ eyeHeight)
			submode: submode
	]
]

{ #category : #projections }
WDSGMultiEyeCamera >> vrHeadsetDescription: aWTVRHeadsetDescription [
	vrHeadset := aWTVRHeadsetDescription.
	projectionMode := #vr.
	eyes first transform translation: vrHeadset leftTranslation.
	eyes first transform translation: vrHeadset rightTranslation.
]

{ #category : #projections }
WDSGMultiEyeCamera >> vrReverseDepthPerspectiveNear: near far: far invertedY: invertedY [
	vrHeadset
		nearDistance: near;
		farDistance: far;
		invertedY: invertedY.
		
	eyes first projectionMatrix: vrHeadset leftUndistortedProjection.
	eyes second projectionMatrix: vrHeadset rightUndistortedProjection.

]

{ #category : #'as yet unclassified' }
WDSGMultiEyeCamera >> vrSensorState: sensorState [
	vrTransform
		orthonormal: sensorState orientation asWMMatrix3 translation: sensorState translation
]

{ #category : #accessing }
WDSGMultiEyeCamera >> vrTransform [
	^ vrTransform
]