Class {
	#name : #WDASceneViewWith2DOverlay,
	#superclass : #WDASceneView,
	#instVars : [
		'hasRenderedOverlayTargets',
		'babylonOverlay',
		'formSceneGraphOverlay',
		'overlaySpatialObject'
	],
	#category : #'WodenEngine-Scene-Application'
}

{ #category : #rendering }
WDASceneViewWith2DOverlay >> babylonDefaultFont [
	^ babylonOverlay defaultFont
]

{ #category : #'drawing 2d' }
WDASceneViewWith2DOverlay >> buildFrameRateUISceneGraphNodeWith: builder [
	| deltaTime lines destPosition font foregroundColor backgroundColor lineDelta lineRectangles |
	deltaTime := engine frameBufferingDriver currentFrameCPUDeltaTime.
	
	lines := self formatFrameRateLines.
	font := self defaultFont.	
	destPosition := 10@10.
	foregroundColor := Color black.
	backgroundColor := Color white alpha: 0.7.
	lineDelta := (0 @font getPreciseHeight).
	
	lineRectangles := lines collect: [:eachLine |
		|linePosition|
		linePosition := destPosition.
		destPosition := destPosition + lineDelta.
		
		linePosition extent: (font widthOfString: eachLine) @ font height.
	].

	^ builder containerWith: {
		builder rectangle: (Rectangle merging: lineRectangles) color: backgroundColor
	} , (lines collectWithIndex: [:line :index |
		builder string: line in: (lineRectangles at: index) font: font color: foregroundColor
	])
]

{ #category : #rendering }
WDASceneViewWith2DOverlay >> buildUISceneGraphWith: builder [
	| result |
	result := builder null.
	WDCEngine displayFrameRate ifTrue: [ 
		result := self buildFrameRateUISceneGraphNodeWith: builder
	].

	^ result

]

{ #category : #rendering }
WDASceneViewWith2DOverlay >> constructRenderingCommandLists [
	hasRenderedOverlayTargets := false.
	^ super constructRenderingCommandLists
]

{ #category : #rendering }
WDASceneViewWith2DOverlay >> defaultFont [
	^ TextStyle defaultFont
]

{ #category : #'drawing 2d' }
WDASceneViewWith2DOverlay >> formatFrameRateLines [
	| deltaTime |
	deltaTime := engine frameBufferingDriver currentFrameCPUDeltaTime.
	
	^ {
		'CPU Frame Rate {1} ms / {2} FPS' format: {
			(deltaTime*1000.0) printShowingDecimalPlaces: 3 .
			1.0 / (deltaTime max: 0.01) printShowingDecimalPlaces: 3.
			engine frameBufferingDriver lastFrameCPUConsumption * 1000.0 printShowingDecimalPlaces: 3
		}.
		'CPU Consumption {1} ms' format: {
			engine frameBufferingDriver lastFrameCPUConsumption * 1000.0 printShowingDecimalPlaces: 3
		}.
		'Rendered object count {1}' format: {
			engine frameRenderingMetrics renderedObjectCount asString
		}.
	}
]

{ #category : #accessing }
WDASceneViewWith2DOverlay >> overlaySpatialObject [
	overlaySpatialObject ifNil: [
		overlaySpatialObject := WDCSpatialObject new engine: engine
	].
	^ overlaySpatialObject
]

{ #category : #rendering }
WDASceneViewWith2DOverlay >> renderViewport: viewport overlayRenderTargetWith: stateTracker [
	hasRenderedOverlayTargets ifTrue: [ ^ self ].

	self validFormSceneGraphOverlay
		scaleFactor: (self isMultiEyeView
			ifTrue: [ nil ]
			ifFalse: [window uiScaleFactor]);
		drawingSurfaceExtent: self drawingSurfaceExtent;
		buildSceneGraphWith: [ :builder :overlay |
			builder withTransform: (FormSGAffineTransform scale: overlay validScaleFactor) build: [
				self buildUISceneGraphWith: builder
			]
		];
		validateSurfaceContentWithStateTracker: stateTracker.
	
	hasRenderedOverlayTargets := true.

	self isMultiEyeView ifTrue: [ 
		| extent aspectRatio overlayHeight overlayDistance |
		extent := self drawingSurfaceExtent.
		aspectRatio := extent x asFloat / extent y asFloat.
		overlayHeight := 0.1.
		overlayDistance := 0.2.
		self overlaySpatialObject
			transform: (ReversibleAffineTransform3dF32 identity
				scaleByX: aspectRatio * overlayHeight y: overlayHeight z: 1.0;
				translateByZ: overlayDistance negated)
	] ifFalse: [
		self overlaySpatialObject
			transform: (ReversibleAffineTransform3dF32 identity)
	].

	overlaySpatialObject
		updateCommonGpuStateForFrame: engine frameBufferingDriver frameIndex

]

{ #category : #rendering }
WDASceneViewWith2DOverlay >> renderViewport: viewport overlayWith: stateTracker [
	formSceneGraphOverlay ifNil: [ ^ self ].
	self isMultiEyeView ifFalse: [ 
		stateTracker useShaderResources: engine resourceCache screenQuadCameraStateBinding.
	].
	self overlaySpatialObject renderRenderable: formSceneGraphOverlay with: stateTracker
]

{ #category : #path }
WDASceneViewWith2DOverlay >> sessionChanged [
	babylonOverlay := nil.
	super sessionChanged
]

{ #category : #'as yet unclassified' }
WDASceneViewWith2DOverlay >> validFormSceneGraphOverlay [
	^ formSceneGraphOverlay ifNil: [ formSceneGraphOverlay := WDCFormSceneGraphRenderable for: engine ]
]
