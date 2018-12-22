#!/usr/bin/osascript
--------------------------------------------------------------------------------
# pnam: FINDER#PASTE CLIPBOARD AS FILE
# nmxt: .applescript
# pDSC: Pastes the contents of the clipboard as a new file in Finder.  The
#       compatible data types are image data (JPG, PNG) and plain text.

# plst: -

# rslt: - : File pasted and revealed in Finder
--------------------------------------------------------------------------------
# sown: CK
# ascd: 2018-04-17
# asmo: 2018-12-15
--------------------------------------------------------------------------------
# IMPLEMENTATION:
on run
	set cb to {data:null, file:null, class:null, name extension:null}
	
	set cbObj to continue the clipboard as record
	try
		set cb's file to cbObj's «class furl» as alias
	on error
		try
			set cb's data to cbObj's string
			set cb's class to «class utf8»
			set cb's name extension to "txt"
		on error
			try
				set cb's data to cbObj's JPEG picture
				set cb's class to JPEG picture
				set cb's name extension to "jpg"
			on error
				return beep
			end try
		end try
	end try
	
	if cb's file ≠ null then
		set type to kind of (info for cb's file)
		if type = "JPEG image" then
			set cb's class to JPEG picture
			set cb's name extension to "jpg"
			
		else if type = "PNG image" then
			set cb's class to «class PNGf»
			set cb's name extension to "png"
			
		else if type contains "text" then
			set cb's class to «class utf8»
			set cb's name extension to "txt"
		else
			return beep
		end if
		
		try
			set cb's data to read cb's file as cb's class
		on error
			set cb's class to «class ut16»
			set cb's data to read cb's file as cb's class
		end try
	end if
	
	set filename to the contents of ["Pasted from clipboard on ", ¬
		current date, ".", cb's name extension] as text
	
	
	tell application "Finder"
		set f to make new file at insertion location as alias ¬
			with properties {name:filename}
		
		write cb's data to (f as alias) as cb's class
		reveal f -- OR: set selection to f
	end tell
end run
--------------------------------------------------------------------------------
# HANDLERS & SCRIPT OBJECTS:
on current date
	set ts to (continue current date) as «class isot» as string
	set my text item delimiters to {" at ", "T"}
	set ts to text items of ts as text
	set my text item delimiters to {".", ":"}
	set ts to text items of ts as text
	
	return text 1 thru -4 of ts
end current date
---------------------------------------------------------------------------❮END❯