#!/usr/bin/osascript
--------------------------------------------------------------------------------
###New Text File.applescript
#
#	Creates a new, blank text file at the current insertion location in
#	Finder.  If an "Untitled Text Document.txt" already exists at that
#	location, a sequential number is appended to the filename. 
#
#  Input:
#	-				
#
#  Result:
#	true				File created in Finder
#	❮string❯			Error whilst trying to create file
--------------------------------------------------------------------------------
#  Author: CK
#  Date Created: 2018-09-22
#  Date Last Edited: 2018-09-23
--------------------------------------------------------------------------------
property sys : application "System Events"
property finder : application "Finder"
--------------------------------------------------------------------------------
property displayed name : "Untitled Text Document"
property name extension : ".txt"
property index : ""
property name : a reference to [my displayed name, my index, my name extension]
property folder : a reference to finder's «class pins»
--------------------------------------------------------------------------------
###IMPLEMENTATION
#
#
set fol to sys's («class cfol» named (my folder as alias))
set fname to my name's contents as text

set f to a reference to file (a reference to fname) of (a reference to fol)

repeat until not (f exists)
	set index to (index as integer) + 1
	if index = 1 then set index to 2
	set index to space & index
	set fname to my name's contents as text
end repeat

try
	sys's (make new file at fol with properties {name:fname}) as alias
on error E
	return E
end try

tell finder to select the result

set index to ""

true
---------------------------------------------------------------------------❮END❯