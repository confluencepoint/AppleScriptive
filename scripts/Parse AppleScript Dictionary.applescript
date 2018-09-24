#!/usr/bin/osascript
--------------------------------------------------------------------------------
###Parse AppleScript Dictionary.applescript
#
#	Parses an .sdef file belonging to the scriptable application whose name
# 	is supplied as input.  A record of AppleScript terminologies for the 
#	application is retrieved, including commands, classes, properties and 
#	elements.
#
#  Input:
#	％input％			The name of a scriptable application
#
#  Result:
#	❮list❯				A list of AppleScript commands
--------------------------------------------------------------------------------
#  Author: CK
#  Date Created: 2018-08-04
#  Date Last Edited: 2018-09-24
--------------------------------------------------------------------------------
property finder : application "Finder"
property sys : application "System Events"
--------------------------------------------------------------------------------
property path : missing value
property file : missing value
--------------------------------------------------------------------------------
property text item delimiters : space
--------------------------------------------------------------------------------
###IMPLEMENTATION
#
#
on run input
	if input's class = script then set input to ["Keyboard Maestro"]
	set [input] to input
	
	set (my path) to path to resource in bundle input
	set my file to sys's «class xmlf» named (my path)
	
	
	set terminology to {commands:contents of command's name ¬
		, |classes|:{|classes|:contents of |class|'s name ¬
		, elements:contents of |class|'s element's name ¬
		, |properties|:contents of |class|'s |property|'s name}} ¬
		of suite of dictionary
	
	flatten(commands of terminology)
end run
--------------------------------------------------------------------------------
###HANDLERS & SCRIPT OBJECTS
#
#
on path to resource in bundle A
	local A
	
	script appbundle
		property name : [A, ".app"] as text
		property appf : a reference to the ¬
			«class appf» named (my name) in the «class ects» of ¬
			finder's «class cfol» (path to applications folder ¬
			as text)
		
		script Resources
			property directory : a reference to «class cfol» ¬
				"Resources" of «class cfol» "Contents" of appf
			property everyfile : a reference to files in ¬
				«class ects» of the directory
			
			script subfolders
				property list : a reference to ¬
					every «class cfol» in the directory
			end script
			
			script |files|
				property name : missing value
				property list : missing value
			end script
			
			to filterFilesByType:ext
				local ext
				
				set ext to "." & word 1 of ext
				
				set name of the |files| to the text items of ¬
					(the name of everyfile as text)
				
				repeat with filename in (a reference to the ¬
					name of the |files|)
					if the filename does not end with ext ¬
						then set the contents of ¬
						the filename to missing value
				end repeat
				
				set the list of |files| to text in the ¬
					name of the |files|
			end filterFilesByType:
		end script
		
		on pathToFolderWithFile given name:filename
			local filename
			
			repeat with F in {the directory of Resources} & ¬
				the list of subfolders in Resources as list
				tell (the file named filename in F) to ¬
					if exists then return it as alias
			end repeat
			
			null
		end pathToFolderWithFile
	end script
	
	tell appbundle's Resources to filterFilesByType:"sdef"
	if the result = {} then return null
	set [sdef] to the list of the |files| in appbundle's Resources
	return pathToFolderWithFile of the appbundle given name:sdef
end path to resource


to flatten(L)
	local L
	
	if L = {} then return {}
	if L's class ≠ list then return {L}
	
	script
		property array : L
	end script
	
	tell the result's array to set [x, xN] ¬
		to [first item, rest] of it
	
	flatten(x) & flatten(xN)
end flatten


script dictionary
	use application "System Events"
	
	property dictionary : a reference to XML element of my file
	property suites : a reference to every XML element in the dictionary
	
	script suite
		property nodes : a reference to every XML element of suites
		property commands : a reference to (nodes whose ¬
			name = "command")
		property |classes| : a reference to (nodes whose ¬
			name = "class")
		
		
		script |command|
			property nodes : a reference to XML elements ¬
				of commands
			property name : a reference to value of ¬
				(XML attributes of commands where ¬
					the name of it = "name")
			property parameters : a reference to (nodes where ¬
				the name of it ends with "parameter")
		end script
		
		script |class|
			property nodes : a reference to XML elements ¬
				of |classes|
			property name : a reference to value of ¬
				(XML attributes of |classes| where ¬
					the name of it = "name")
			property elements : a reference to (nodes where ¬
				the name of it = "element")
			property |properties| : a reference to (nodes where ¬
				the name of it = "property")
			
			script element
				property name : a reference to value of ¬
					(XML attributes of elements where ¬
						the name of it = "type")
			end script
			
			script |property|
				property name : a reference to value of ¬
					(XML attributes of |properties| where ¬
						the name of it = "name")
			end script
		end script
	end script
end script
---------------------------------------------------------------------------❮END❯