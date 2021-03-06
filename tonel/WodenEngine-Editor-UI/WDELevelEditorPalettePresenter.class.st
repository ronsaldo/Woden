Class {
	#name : #WDELevelEditorPalettePresenter,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'treeView'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #specs }
WDELevelEditorPalettePresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #treeView;
		yourself
		
]

{ #category : #'as yet unclassified' }
WDELevelEditorPalettePresenter >> fetchTopLevelPaletteCategories [
	^ #()
]

{ #category : #initialization }
WDELevelEditorPalettePresenter >> initializePresenters [
	treeView := self newTreeTable.
	treeView
		addColumn: (SpCompositeTableColumn new
			title: 'Name';
			addColumn: (SpStringTableColumn evaluated: [ :node | node name ]);
			addColumn: (SpImageTableColumn evaluated: [ :node | node thumbnail ]);
			yourself
		);
		hideColumnHeaders;
		children: [ :node | node children ];
		whenActivatedDo: [
			treeView selectedItem ifNotNil: [ :item | item activateInLevelSession: self model ]
		];
		whenSelectionChangedDo: [ :selection |
			self setSelectedPaletteElement: (selection selectedItem ifNotNil: [:i | i asPaletteElement])
		].

]

{ #category : #initialization }
WDELevelEditorPalettePresenter >> modelChanged [
	treeView roots: self fetchTopLevelPaletteCategories.
]

{ #category : #initialization }
WDELevelEditorPalettePresenter >> setSelectedPaletteElement: paletteElement [
	"By default do nothing."
]

{ #category : #accessing }
WDELevelEditorPalettePresenter >> treeView [
	^ treeView
]

{ #category : #accessing }
WDELevelEditorPalettePresenter >> treeView: anObject [
	treeView := anObject
]
