Class {
	#name : #WDESFPSPlayerBehaviorComponent,
	#superclass : #WDESCharacterBehaviorComponent,
	#traits : 'TInputControllerBehavior',
	#classTraits : 'TInputControllerBehavior classTrait',
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #'event handling' }
WDESFPSPlayerBehaviorComponent >> onJoyAxis: event [
	| value |
	event mapped ifFalse: [ ^ self ].
	value := self gamepadMapAxis: event value.

	event isLeftX ifTrue: [ 
		leftStickDirection x: value
	].

	event isLeftY ifTrue: [
		leftStickDirection y: value negated
	].

	event isRightX ifTrue: [ 
		rightStickDirection x: value
	].

	event isRightY ifTrue: [
		rightStickDirection y: value negated
	].

	event isTriggerRight ifTrue: [
		self running: (self gamepadMapTriggerBinary: event value) > 0.
	].
]

{ #category : #'event handling' }
WDESFPSPlayerBehaviorComponent >> onJoyButtonDown: event [
	event mapped ifFalse: [ ^ self ].
	event isButtonX ifTrue: [ displacementStrategy activateUseCommand ].
	event isButtonA ifTrue: [ leftStickDirection z: 1.0 ].
	event isLeftShoulder ifTrue: [ leftStickDirection z: -1.0 ].
]

{ #category : #'event handling' }
WDESFPSPlayerBehaviorComponent >> onJoyButtonUp: event [
	event mapped ifFalse: [ ^ self ].
	event isButtonA ifTrue: [ leftStickDirection z > 0.0 ifTrue: [ leftStickDirection z: 0.0 ] ].
	event isLeftShoulder ifTrue: [ leftStickDirection z < 0.0 ifTrue: [ leftStickDirection z: 0.0 ] ].
]

{ #category : #'event handling' }
WDESFPSPlayerBehaviorComponent >> onKeyDown: event [
	event repeat > 0 ifTrue: [ ^ 0 ].

	event symbol = OSK_a ifTrue: [ leftStickDirection x: -1.0 ].
	event symbol = OSK_d ifTrue: [ leftStickDirection x: 1.0 ].
	event symbol = OSK_s ifTrue: [ leftStickDirection y: -1.0 ].
	event symbol = OSK_w ifTrue: [ leftStickDirection y: 1.0 ].
	event symbol = OSK_LCTRL ifTrue: [ leftStickDirection z: -1.0 ].
	event symbol = OSK_SPACE ifTrue: [ leftStickDirection z: 1.0 ].

	event symbol = OSK_UP ifTrue: [ rightStickDirection y: 1.0 ].
	event symbol = OSK_DOWN ifTrue: [ rightStickDirection y: -1.0 ].
	event symbol = OSK_LEFT ifTrue: [ rightStickDirection x: -1.0 ].
	event symbol = OSK_RIGHT ifTrue: [ rightStickDirection x: 1.0 ].

	event symbol = OSK_e ifTrue: [ displacementStrategy activateUseCommand ].
	event symbol = OSK_LSHIFT ifTrue: [ self running: true ].



	(event symbol = OSK_i and: [ event modifiers ctrl ]) ifTrue: [ self inspect ].
]

{ #category : #'event handling' }
WDESFPSPlayerBehaviorComponent >> onKeyUp: event [
	event symbol = OSK_a ifTrue: [ leftStickDirection x < 0 ifTrue: [ leftStickDirection x: 0.0 ] ].
	event symbol = OSK_d ifTrue: [ leftStickDirection x > 0 ifTrue: [ leftStickDirection x: 0.0 ] ].
	event symbol = OSK_s ifTrue: [ leftStickDirection y < 0 ifTrue: [ leftStickDirection y: 0.0 ] ].
	event symbol = OSK_w ifTrue: [ leftStickDirection y > 0 ifTrue: [ leftStickDirection y: 0.0 ] ].
	event symbol = OSK_LCTRL ifTrue: [ leftStickDirection z < 0 ifTrue: [ leftStickDirection z: 0.0 ] ].
	event symbol = OSK_SPACE ifTrue: [ leftStickDirection z > 0 ifTrue: [ leftStickDirection z: 0.0 ] ].

	event symbol = OSK_LEFT ifTrue: [ rightStickDirection x < 0 ifTrue: [ rightStickDirection x: 0.0 ] ].
	event symbol = OSK_RIGHT ifTrue: [ rightStickDirection x > 0 ifTrue: [ rightStickDirection x: 0.0 ] ].
	event symbol = OSK_UP ifTrue: [ rightStickDirection y > 0 ifTrue: [ rightStickDirection y: 0.0 ] ].
	event symbol = OSK_DOWN ifTrue: [ rightStickDirection y < 0 ifTrue: [ rightStickDirection y: 0.0 ] ].

	event symbol = OSK_LSHIFT ifTrue: [ self running: false ].


]

{ #category : #'event handling' }
WDESFPSPlayerBehaviorComponent >> onMouseMotion: event [
	| angleScale |
	self isInVirtualReality ifTrue: [ ^ self ].
	angleScale := Float pi / 180.0 * 0.25.
	headAngle := headAngle + (Float32x3 x: event delta y * angleScale negated y: event delta x * angleScale negated z: 0.0)
]

{ #category : #'event handling' }
WDESFPSPlayerBehaviorComponent >> onVRCameraTransform: newCameraTransform [
	ownerEntity isInVirtualReality: true.
	self applyVRHeadTransform: newCameraTransform.
]
