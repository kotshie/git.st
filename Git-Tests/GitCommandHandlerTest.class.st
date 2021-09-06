Class {
	#name : #GitCommandHandlerTest,
	#superclass : #TestCase,
	#instVars : [
		'handler'
	],
	#category : #'Git-Tests'
}

{ #category : #initialization }
GitCommandHandlerTest >> setUp [
	super setUp.
	handler := GitCommandHandler new 

]

{ #category : #tests }
GitCommandHandlerTest >> testGitInitWithDot [
	handler setArguments: #('git' 'init' '.').
	self halt.
	
]

{ #category : #tests }
GitCommandHandlerTest >> testGitInitWithNoPath [
]

{ #category : #tests }
GitCommandHandlerTest >> testGitInitWithPath [
]
