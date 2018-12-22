#!/usr/bin/osascript
--------------------------------------------------------------------------------
# pnam: LIST & RECORD PRINTER
# nmxt: .applescript
# pDSC: Pretty prints a text representation of an AppleScript list or record

# plst: +input : A list or record or a valid string representation of such

# rslt: «ctxt» : Pretty-printed string representation of the input
--------------------------------------------------------------------------------
# sown: CK
# ascd: 2018-10-20
# asmo: 2018-12-21
# vers: 2.0
--------------------------------------------------------------------------------
# IMPLEMENTATION:
on run input
	if input's class = script then set input to [{¬
		[1, 2, {a:3, b:4}, "Hello, \"World!\""], ¬
		{c:{alpha:1, beta:"foo{bar}"}, d:"5"}, ¬
		"6", [7, {8, 9}, 0] ¬
		}]
	set [input] to the input
	set input to characters of __string(input)
	
	foldItems from the input at {"", 0, false} given handler:tabulate
	item 1 of the result
end run
--------------------------------------------------------------------------------
# HANDLERS & SCRIPT OBJECTS:
on __(function)
	if the function's class = script ¬
		then return the function
	
	script
		property fn : function
	end script
end __


to __string(obj)
	local obj
	
	if obj's class = text then return obj
	
	try
		{_:obj} as text
	on error E --> "Can’t make %object% into type text."
		set text item delimiters to {"Can’t make ", ¬
			" into type text."}
		text item 2 of E
	end try
	
	result's text 4 thru -2
end __string


to foldItems from L at |ξ| : 0 given handler:function
	local L, |ξ|, function
	
	script
		property list : L
	end script
	
	tell the result to repeat with i from 1 to length of its list
		set x to item i in its list
		tell __(function)'s fn(x, |ξ|, i, L) to ¬
			if it = null then
				exit repeat
			else
				set |ξ| to it
			end if
	end repeat
	
	|ξ|
end foldItems


on _tab(N)
	if N = 0 then return ""
	tab & _tab(N - 1)
end _tab


to tabulate(y, |ξ|, i, L)
	set [t, N, q] to |ξ|
	
	if i > 1 then set x to item (i - 1) of L
	if i < L's length then set z to item (i + 1) of L
	
	if y = "\"" and i ≠ 1 and x ≠ "\\" then return [t & y, N, not q]
	if q then return [t & y, N, q]
	if y is in "{[" then return [t & y & return & _tab(N + 1), N + 1, q]
	if y = " " and x = "," then return [t & y & return & _tab(N), N, q]
	if y is in "}]" then return [t & return & _tab(N - 1) & y, N - 1, q]
	if y = ":" then return [t & y & space, N, q]
	[t & y, N, q]
end tabulate
---------------------------------------------------------------------------❮END❯