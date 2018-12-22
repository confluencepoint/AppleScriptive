#!/usr/bin/osascript
--------------------------------------------------------------------------------
# pnam: _TEXT
# nmxt: .applescript
# pDSC: String manipulation handlers.  Loading this library also loads _lists 
#       lib.  For a string replace function, use _regex lib.
--------------------------------------------------------------------------------
# sown: CK
# ascd: 2018-08-31
# asmo: 2018-12-22
--------------------------------------------------------------------------------
property name : "_text"
property id : "chri.sk.applescript._text"
property version : 1.0
property _text : me
property libload : script "load.scpt"
property parent : libload's load("_lists")
--------------------------------------------------------------------------------
property tid : AppleScript's text item delimiters
--------------------------------------------------------------------------------
# HANDLERS & SCRIPT OBJECTS:

# __string()
#   Returns a string representation of an AppleScript object
to __string(obj)
	if class of obj = text then return obj
	
	try
		set s to {_:obj} as text
	on error E
		my tid:{"Can’t make {_:"}
		set s to text items 2 thru -1 of E as text
		
		my tid:{"} into type text."}
		set s to text items 1 thru -2 of s as text
		
		my tid:{}
	end try
	
	s
end __string

# __text()
#   Joins a list of characters together without any delimiters
to __text(chars as linked list)
	chars as text
end __text

# __class()
#   Takes the text name of an AppleScript class and returns the corresponding
#   type class object, or 0 if the input doesn't correspond to an AppleScript
#   class.  Chevron syntax codes can be used as input, e.g. __class("orig").
on __class(str as text)
	local str
	
	try
		run script str & " as class"
	on error
		try
			set str to text 1 thru 4 of (str & "   ")
			run script "«class " & str & "» as class"
		on error
			0
		end try
	end try
end __class

# tid:
#   Sets AppleScript's text item delimiters to the supplied value.  If this
#   value is {} or 0, the text item delimiters are reset to their previous
#   value.
on tid:(d as list)
	local d
	
	if d = {} or d = {0} then
		set d to tid
	else if d's item 1 = null then
		set N to random number from 0.0 to 1.0
		set d's first item to N / pi
	end if
	
	set tid to AppleScript's text item delimiters
	set AppleScript's text item delimiters to d
end tid:

# join() [ syn. glue() ]
#   Joins a list of items (+t) together using the supplied delimiter (+d)
to join(t as list, d as list)
	tid_(d)
	set t to t as text
	tid_(0)
	t
end join
to glue(t, d)
	join(t, d)
end glue

# split() [ syn. unjoin() ]
#   Splits text (+t) into a list of items wherever it encounters the supplied
#   delimiter (+d)
on split(t as text, d as list)
	tid_(d)
	set t to text items of t
	tid_(0)
	t
end split
to unjoin(t, d)
	split(t, d)
end unjoin

# offset
#   Returns the indices of each occurrence of a substring (+str) in a given
#   string (+txt)
on offset of txt in str
	local txt, str
	
	if txt is not in str then return {}
	
	tid_(txt)
	
	script
		property N : txt's length
		property t : {1 - N} & str's text items
	end script
	
	tell the result
		repeat with i from 2 to (its t's length) - 1
			set item i of its t to (its N) + ¬
				(length of its t's item i) + ¬
				(its t's item (i - 1))
		end repeat
		
		tid_(0)
		
		items 2 thru -2 of its t
	end tell
end offset

# rev()
#   gnirts a sesreveR
on rev(t as text)
	local t
	
	__text(reverse of characters of t)
end rev

# uppercase()
#   RETURNS THE SUPPLIED STRING FORMATTED IN UPPERCASE (A-Z ONLY)
to uppercase(t as text)
	local t
	
	script capitalise
		property s : id of t
		
		to fn(x)
			if 97 ≤ x and x ≤ 122 then ¬
				return x - 32
			x's contents
		end fn
	end script
	
	mapItems from s of capitalise given handler:capitalise
	character id result
end uppercase

# lowercase()
#   returns the supplied string formatted in lowercase (a-z only)
to lowercase(t as text)
	local t
	
	script decapitalise
		property s : id of t
		
		to fn(x)
			if 65 ≤ x and x ≤ 90 then ¬
				return x + 32
			x's contents
		end fn
	end script
	
	mapItems from s of decapitalise given handler:decapitalise
	character id result
end lowercase

# titlecase()
#   Returns The Supplied String Formatted In Titlecase (A-Z Only)
to titlecase(t as text)
	local t
	
	script titlecase
		property s : id of t
		
		to fn(x, i, L)
			if i = 1 or item (i - 1) of L ¬
				is in [32, 9, 10, 13] then
				if 97 ≤ x and x ≤ 122 then ¬
					return x - 32
			else if 65 ≤ x and x ≤ 90 then
				return x + 32
			end if
			x's contents
		end fn
	end script
	
	mapItems from s of titlecase given handler:titlecase
	character id result
end titlecase

# substrings()
#   Returns every substring of a given string
on substrings(t)
	local t
	
	script
		property result : {}
		
		to iterate thru s at N : 1
			local s, N
			
			if the length of s < N then return {}
			set my result to my result & (text 1 thru N of s)
			iterate thru s at N + 1
		end iterate
		
		to recurse thru s
			local s
			
			if the length of s = 1 then return s
			iterate thru s
			my result & substrings(text 2 thru -1 of s)
		end recurse
	end script
	
	tell the result to recurse thru t
end substrings

# LCS()
#   Returns the longest common substring of two strings
on LCS(a as text, b as text)
	local t1, t2
	
	script
		property s : substrings(a)
		property t : substrings(b)
		property list : missing value
		
		on longest from L at w : ""
			if length of L = 1 then return w
			
			tell item 1 of L to if ¬
				w's length < its length ¬
				then set w to it
			
			longest from the rest of L at w
		end longest
	end script
	
	tell the result
		repeat with x in (a reference to its s)
			if x is not in its t then set ¬
				the contents of x to null
		end repeat
		
		set its list to every string in its s
		
		longest from its list
	end tell
end LCS

# anagrams()
#   Lists every permutation of character arrangement for a given string
on anagrams(t as text)
	local t
	
	script
		property s : characters of t
		property result : {}
		
		
		to permute(i, N)
			local i, N
			
			if i > N then set end of my result to s as text
			
			repeat with j from i to N
				swap(s, i, j)
				permute(i + 1, N)
				swap(s, i, j)
			end repeat
		end permute
	end script
	
	tell the result
		permute(1, length of t)
		unique_(its result)
	end tell
end anagrams
---------------------------------------------------------------------------❮END❯