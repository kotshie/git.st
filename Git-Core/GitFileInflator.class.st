Class {
	#name : #GitFileInflator,
	#superclass : #Object,
	#instVars : [
		'path'
	],
	#category : #'Git-Core'
}

{ #category : #accessing }
GitFileInflator >> contents [
	^(ZLibReadStream on: (self path asFileReference binaryReadStream)) contents 
]

{ #category : #accessing }
GitFileInflator >> contentsString [
	^self contents asString
]

{ #category : #accessing }
GitFileInflator >> path [

	^ path
]

{ #category : #accessing }
GitFileInflator >> path: anObject [

	path := anObject
]
