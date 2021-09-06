Class {
	#name : #GitCommandHandler,
	#superclass : #ClapApplication,
	#instVars : [
		'outStream'
	],
	#category : #'Git-Core'
}

{ #category : #'as yet unclassified' }
GitCommandHandler class >> clapCommand [
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
		" Handler other commands "
		meaning: [ :args |
			args at: #helpFlag ifPresent: [ :help | help value; exitSuccess ].
			(self with: args) execute
		];
		yourself.


]

{ #category : #execution }
GitCommandHandler >> execute [
	self outStream nextPutAll: 'Unknown command/subcommand'.
	Exit signalFailure.

]

{ #category : #accessing }
GitCommandHandler >> outStream [
	^ outStream ifNil: [ outStream := VTermOutputDriver on: arguments context stdout ]
]

{ #category : #accessing }
GitCommandHandler >> status [ 
	self outStream nextPutAll: 'STATUS'.
	Exit signalSuccess.
	
]
