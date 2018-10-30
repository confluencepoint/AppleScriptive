#!/usr/bin/osascript
--------------------------------------------------------------------------------
# pnam: LOAD
# nmxt: .applescript
# comt: This is the text version of load.scpt for the purposes of online viewing
# pDSC: Enables loading of non-compiled AppleScripts from a custom location.
#       Also provides top-level handlers and properties to scripts invoking 
#       this as its parent.
--------------------------------------------------------------------------------
# sown: CK
# ascd: 2018-08-07
# asmo: 2018-10-30
--------------------------------------------------------------------------------
property name : "libload"
property id : "chri.sk.applescript.lib.load"
property version : 1.0
property libload : me
property parent : AppleScript
--------------------------------------------------------------------------------
property root : "~/Documents/Scripts/AppleScript/scripts"
--------------------------------------------------------------------------------
property this : a reference to current application
property sys : application "System Events"
property Finder : application "Finder"
--------------------------------------------------------------------------------
# HANDLERS & SCRIPT OBJECTS:
on dir(f as text)
	set f to POSIX path of f
	(POSIX file f as alias as text) & "::" as alias
	POSIX path of result
end dir

to load script s
	local s
	
	script
		property f : _path to (s as text)
		property tmp : "/tmp/load.scpt"
		
		to load()
			if f = false then return AppleScript
			
			if f ends with ".scpt" then
				tell the current application to ¬
					set s to load script f
			else
				set sh to contents of [¬
					"osacompile -o ", ¬
					tmp, space, ¬
					f's quoted form] as text
				
				do shell script sh
				
				set s to load script tmp
				delete sys's file tmp
			end if
			
			s
		end load
	end script
	
	result's load()
end load script


on _path to f
	local f
	
	if f's class is in [null, constant, script, application] then ¬
		return _path to POSIX path of (path to f)
	
	set f to f as text
	
	-- Default to folder "lib" in root folder if none supplied
	if "/" is not in f then set f to («class posx» of ¬
		item named "lib" in sys's item root) & "/" & f
	-- Append .applescript extension if none
	if not (f ends with ".scpt" or f ends with ".applescript") ¬
		then set f to f & ".applescript"
	
	-- If file is an alias to an original, get its source
	set f to Finder's file (sys's file f as alias)
	tell (f's «class orig») to if exists then set f to it
	
	POSIX path of (f as alias)
end _path
---------------------------------------------------------------------------❮END❯