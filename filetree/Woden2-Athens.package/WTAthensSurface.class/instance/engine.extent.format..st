initialization
engine: aWTEngine extent: anExtent format: aTextureFormat
	engine := aWTEngine.
	extent := anExtent asIntegerPoint.
	colorBufferFormat := aTextureFormat.
	self initializeForNewSession.