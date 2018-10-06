#!/usr/bin/osascript
--------------------------------------------------------------------------------
###Hostnames.applescript
#
#	Lists hostnames of available devices found on the local network
#
#  Input:
#	-			
#
#  Result:
#	❮list❯				List of IP address/hostname pairs
--------------------------------------------------------------------------------
#  Author: CK
#  Date Created: 2018-09-01
#  Date Last Edited: 2018-10-06
--------------------------------------------------------------------------------
use framework "Foundation"
use scripting additions

property this : a reference to current application
property NSHost : a reference to NSHost of this
--------------------------------------------------------------------------------
property text item delimiters : "."
property subnet : text items 1 thru 3 of IPv4 address of (system info) as text
--------------------------------------------------------------------------------
###IMPLEMENTATION
#
#
on run
	script lan
		property hosts : make my array at 254
	end script
	
	repeat with host in (a reference to hosts of lan)
		set addr to contents of {subnet, host} as text
		tell (NSHost's hostWithAddress:addr)'s |name|() to if ¬
			it ≠ missing value then set the contents of ¬
			host to [addr, it as text]
	end repeat
	
	lists in lan's hosts
end run

script array
	to make at N
		local N
		
		script array
			property list : {}
		end script
		
		tell the array's list
			repeat with i from 1 to N
				set its end to i
			end repeat
			
			it
		end tell
	end make
end script
---------------------------------------------------------------------------❮END❯