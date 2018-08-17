#!/usr/bin/osascript
--------------------------------------------------------------------------------
###Move Window Left or Right.applescript
#
#	Shifts the currently focussed window left- or rightwards to align
#	itself with the contralateral edge of closest window in its path,
#	or to the edge of the screen if no windows remain. 
#
#  Input:
#	％t％			An integer whose sign determines the direction
#				of travel: left (-), right (+).
#
#  Result:
#	-			Window moves
--------------------------------------------------------------------------------
#  Author: CK
#  Date Created: 2018-02-26
#  Date Last Edited: 2018-08-17
--------------------------------------------------------------------------------
###IMPLEMENTATION
#
#
on run t
	if (count t) = 0 then set t to [-1]
	set [t] to t
	
	moveWindow(t)
end run
--------------------------------------------------------------------------------
###HANDLERS
#
#
to moveWindow(t as integer)
	script win
		use application "System Events"
		
		property _P : a reference to every process
		#property _Q : a reference to ¬
		#	(_P whose class of windows contains window)
		property _W : a reference to every window of ¬
			(_P whose visible = true)
		property P : item 1 of (_P whose frontmost = true)
		property W : front window of P
		-- Desktop:
		property D : size of scroll area 1 of process "Finder"
		
		property moveLeft : t < 0
		
		property xs : everyNthItem of (flatten(position of _W)) by 2
		property ws : everyNthItem of (flatten(size of _W)) by 2
		property |x+w| : sort(unique(add(xs, ws)))
		
		property xy : W's position
		property WxH : W's size
	end script
	
	tell win
		set screenX to item 1 of its D
		set [|left|, top] to [item 1, item 2] of its xy
		set [width, height] to [item 1, item 2] of its WxH
		
		if |left| ≤ 0 and its moveLeft = true then return
		if its moveLeft = false and ¬
			(|left| + width + 1) ≥ screenX then ¬
			return
		
		if its moveLeft then
			repeat with x in the reverse of its |x+w|
				if (x + 1) < |left| then
					set «class posn» of its W to ¬
						[x + 1, top]
					return
				end if
			end repeat
			
			set «class posn» of its W to [0, top]
		else
			repeat with x in sort(unique(its xs))
				if (x - 1) > (|left| + width) then
					set «class posn» of its W to ¬
						[x - width - 1, top]
					return
				end if
			end repeat
			
			set «class posn» of its W to [screenX - width, top]
		end if
	end tell
end moveWindow
--------------------------------------------------------------------------------
###LIST MANIPULATION HANDLERS
#
#
to add(A as list, B as list)
	if A = {} and B = {} then return {}
	if A = {} then set A to {0}
	if B = {} then set B to {0}
	
	script
		property Array1 : A
		property Array2 : B
	end script
	
	tell the result
		set x to (item 1 of its Array1) + (item 1 of its Array2)
		{x} & add(rest of its Array1, rest of its Array2)
	end tell
end add

to flatten(L)
	local L
	
	if L = {} then return {}
	if L's class ≠ list then return {L}
	
	script
		property Array : L
	end script
	
	tell the result to set [x0, xN] to ¬
		[first item, rest] of its Array
	
	flatten(x0) & flatten(xN)
end flatten

on everyNthItem of (L as list) from i as integer : 1 by n as integer : 2
	local L, i, n
	
	if (i > L's length) then return {}
	
	script
		property Array : items i thru -1 of L
		property m : {}
	end script
	
	tell the result
		repeat with j from 1 to its Array's length by n
			set end of its m to item j of its Array
		end repeat
		
		its m
	end tell
end everyNthItem

on unique(L as list)
	local L
	
	if L = {} then return {}
	
	script
		property Array : L
	end script
	
	tell the result's Array
		repeat with i from 1 to (its length) - 1
			set [x, xN] to its [item i, ¬
				items (i + 1) thru -1]
			if x is in xN then set its item i to null
		end repeat
		
		classes & files & aliases & ¬
			booleans & dates & ¬
			strings & numbers
	end tell
end unique

to sort(L as list)
	local L
	
	if L = {} then return {}
	if L's length = 1 then return L
	
	script
		property Array : L
	end script
	
	tell the result's Array
		set [x0, xN, i] to [¬
			a reference to its first item, ¬
			a reference to the rest of it, ¬
			(my lastIndexOf(my minimum(it), it))]
		my swap(it, 1, i)
	end tell
	
	{x0's contents} & sort(xN's contents)
end sort

on minimum(L as list)
	local L
	
	if L = {} then return {}
	if L's length = 1 then return L's first item
	if (numbers of L ≠ L) and (strings of L ≠ L) then return
	
	script
		property Array : L
	end script
	
	tell the result's Array to set [x0, xN] to [¬
		(its first item), the rest of it]
	
	tell minimum(xN) to if it < x0 then return it
	return x0
end minimum

on lastIndexOf(x, L)
	local x, L
	
	if L = {} or (x is not in L) then return 0
	if L's class = text then set L to L's characters
	
	script
		property Array : reverse of L
	end script
	
	tell the result's Array to repeat with i from 1 to its length
		if x = its item i then return 1 + (its length) - i
	end repeat
	
	0
end lastIndexOf

to swap(L as list, i as integer, j as integer)
	local i, j, L
	
	if i = j then return
	
	set x to item i of L
	set item i of L to item j of L
	set item j of L to x
end swap
---------------------------------------------------------------------------❮END❯