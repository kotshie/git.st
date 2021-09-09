Class {
	#name : #GitCommandHandler,
	#superclass : #ClapApplication,
	#instVars : [
		'outStream'
	],
	#category : #'Git-Core'
}

{ #category : #'as yet unclassified' }
GitCommandHandler class >> gitCommand [
	<commandline>
	^(ClapCommand id: 'git')
		description: 'Smalltalk implementation of Git client';
		add: ClapCommand forHelp;
		add: ClapFlag forHelp;
		add: (
			(ClapCommand id: 'status')
				description: 'Show working tree status';
				meaning: [ :args | (self with: args) status ]
		);
		add: self initCommand;
		add: ((ClapCommand id: 'commit')
			description: 'Commit changes.';
			meaning: [ :args | (self with: args) commit ]
		);
		" Handler other commands "
		meaning: [ :args |
			args at: #helpFlag ifPresent: [ :help | help value; exitSuccess ].
			(self with: args) execute
		];
		yourself.


]

{ #category : #'as yet unclassified' }
GitCommandHandler class >> initCommand [
	^ (ClapCommand id: 'init')
		description: 'Initialize a new repository.';
		add: (
			(ClapPositional id: #path)
				description: 'path to init repository.';
				implicitMeaning: [ '.' ]
		);
		meaning: [ :args | 
			(self with: args) init 
		].

]

{ #category : #'git-commands' }
GitCommandHandler >> commit [
]

{ #category : #execution }
GitCommandHandler >> execute [
	self outStream nextPutAll: 'Unknown command/subcommand'.
	Exit signalFailure.

]

{ #category : #'git-commands' }
GitCommandHandler >> init [
	"TODO: move into a separate object"
	| args path cwd rootPath gitPath |
	" gets arguments "
	args := self context arguments.
	
	" is path present if not use . "
	path := args size < 3
		ifTrue: [ '.' ]
		ifFalse: [ args at: 3 ].
		
	" get current directory "
	cwd := FileSystem disk workingDirectoryPath.
	
	" rootPath and dotGit path"
	rootPath := (path = '.') 
		ifFalse: [ cwd / path ]
		ifTrue: [ cwd ].
	gitPath := rootPath / '.git'.
	
	rootPath asFileReference exists ifFalse: [ rootPath asFileReference createDirectory ].
	" TODO: Check if directory exists, add overwrite behaviour "
	gitPath asFileReference createDirectory.
	
	" TODO: On windows .git create directory does not become hidden by default, fix this."
	
	"Create Objects and Refs directories"
	(gitPath / 'objects') asFileReference createDirectory.
	(gitPath / 'refs') asFileReference createDirectory.
	(gitPath / 'hooks') asFileReference createDirectory.
	(gitPath / 'info') asFileReference createDirectory.
	
	(gitPath / 'objects' / 'info') asFileReference createDirectory.
	(gitPath / 'objects' / 'pack') asFileReference createDirectory.
	(gitPath / 'refs' / 'heads') asFileReference createDirectory.
	(gitPath / 'refs' / 'tags') asFileReference createDirectory.
	
	(gitPath / 'config') asFileReference createFile.
	(gitPath / 'description') asFileReference createFile.
	(gitPath / 'HEAD') asFileReference createFile.
	(gitPath / 'HEAD') asFileReference writeStreamDo: [ :stream | 
		stream nextPutAll: 'ref: refs/heads/master'.
	].

	self outStream 
		nextPutAll: 'Initialized and empty Git Repository in ';
		nextPutAll: gitPath fullName.
		
	self context exitSuccess.
	

]

{ #category : #initialization }
GitCommandHandler >> initialize [
	super initialize.
]

{ #category : #accessing }
GitCommandHandler >> outStream [
	^ outStream ifNil: [ outStream := VTermOutputDriver on: arguments context stdout ]
]

{ #category : #'git-commands' }
GitCommandHandler >> status [ 
	self outStream nextPutAll: 'STATUS'.
	self context exitSuccess.
	
]
