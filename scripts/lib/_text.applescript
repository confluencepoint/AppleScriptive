#!/usr/bin/osascript
--------------------------------------------------------------------------------
# pnam: _TEXT
# nmxt: .applescript
# pDSC: String manipulation handlers
--------------------------------------------------------------------------------
# sown: CK
# ascd: 2018-08-31
# asmo: 2018-10-31
--------------------------------------------------------------------------------
property name : "_text"
property id : "chrisk.applescript._text"
property version : 1.0
property _text : me
property parent : script "load.scpt"
property _array : load script "_array"
--------------------------------------------------------------------------------
property tid : AppleScript's text item delimiters
--------------------------------------------------------------------------------
# HANDLERS & SCRIPT OBJECTS:
on tid:(d as list)
	local d
	
	if d = {} or d = {0} then
		set d to tid
	else if d's item 1 = null then
		set d's first item ¬
			to (1 / pi) * (random number from 0.0 to 1.0)
	end if
	
	set tid to AppleScript's text item delimiters
	set AppleScript's text item delimiters to d
end tid:
---------------------------------------------------------------------------❮END❯