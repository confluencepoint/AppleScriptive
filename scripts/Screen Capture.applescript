#!/usr/bin/osascript
--------------------------------------------------------------------------------
# pnam: SCREEN CAPTURE
# nmxt: .applescript
# pDSC: Starts a screen capture in window selection mode, saving the image in
#       to the default screenshots folder with a timestamped filename

# plst: *options «text» : The file extension to use for the image 
#                «bool» : Whether or not to reveal the file in Finder

# rslt: «true» : Successful capture
#       «ctxt» : Error message
--------------------------------------------------------------------------------
# sown: CK
# ascd: 2018-02-24
# asmo: 2018-10-25
--------------------------------------------------------------------------------
property types : ["jpg", "png", "tiff", "pdf"]
property cmd : "defaults read com.apple.screencapture location"
property ScreenshotsFolder : do shell script cmd
property text item delimiters : space
--------------------------------------------------------------------------------
on run options
	if class of options = script then set options to ["jpg", true]
	set [type, reveal] to options
	
	-- Create Posix Path for new screenshot and ensure uniqueness
	set fp to the contents of [¬
		ScreenshotsFolder, "/", ¬
		{"Screen Shot", iso(date), "at", iso(hours)}, ¬
		".", type] as text
	
	set Screenshot to validate(fp) as POSIX file
	
	try
		contents of {"SCREENCAPTURE", "-ixWoa", "-t", type, ¬
			quoted form of Screenshot's POSIX path} as text
		do shell script result
	on error E
		return E
	end try
	
	if reveal then tell application "Finder"
		reveal the Screenshot
		activate
	end tell
	
	true
end run
--------------------------------------------------------------------------------
# HANDLERS & SCRIPT OBJECTS:
to validate(fp)
	script
		property displayed name : basename(fp)
		property index : null
		property name extension : extension(fp)
		property filename : a reference to [displayed name, my index, ¬
			name extension]
		property folder : POSIX file dirpath(fp) as alias
		
		on newfile(i as integer)
			local i
			
			set my index to [space, "#", i]
			if 1 ≥ i then set my index to ""
			
			script
				property Finder : application "Finder"
				property name : contents of my filename
				property path : contents of [my folder, my name]
				property file : a reference to Finder's ¬
					file (path as text)
			end script
			
			tell the result
				if its file exists then return newfile(i + 1)
				POSIX path of (its path as text)
			end tell
		end newfile
	end script
	
	result's newfile(0)
end validate

on basename(fp)
	set [text item delimiters, tid] to ["/", text item delimiters]
	set base to fp's last text item
	set text item delimiters to "."
	set base to base's text items 1 thru -2 as text
	set text item delimiters to tid
	
	base
end basename

on extension(fp)
	set [text item delimiters, tid] to [".", text item delimiters]
	set ext to "." & fp's last text item
	set text item delimiters to tid
	
	ext
end extension

on dirpath(fp)
	set [text item delimiters, tid] to ["/", text item delimiters]
	set dir to fp's text items 1 thru -2 as text
	set text item delimiters to tid
	
	dir
end dirpath

on iso(x)
	if x = date then return do shell script "date +'%Y-%m-%d'"
	do shell script "date +'%H.%M'"
end iso
---------------------------------------------------------------------------❮END❯