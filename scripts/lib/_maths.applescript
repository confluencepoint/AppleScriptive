#!/usr/bin/osascript
--------------------------------------------------------------------------------
# pnam: _MATHS
# nmxt: .applescript
# pDSC: Mathematical functions.  Loading this library also loads _arrays lib.
--------------------------------------------------------------------------------
# sown: CK
# ascd: 2018-11-04
# asmo: 2018-11-07
--------------------------------------------------------------------------------
property name : "_maths"
property id : "chri.sk.applescript._maths"
property version : 1.0
property _maths : me
property libload : script "load.scpt"
property parent : libload's load("_arrays")
--------------------------------------------------------------------------------
# HANDLERS & SCRIPT OBJECTS:
script Node
	script Node
		property data : missing value
		property |left| : null
		property |right| : null
	end script
	
	to make with data d
		set N to Node
		set N's data to d
		return N
	end make
end script

# GCD:
#   Returns the greatest common divisor of a list of integers
on GCD:L
	local L
	
	script
		property array : L
		
		on GCD(x, y)
			local x, y
			
			repeat
				if x = 0 then return y
				set [x, y] to [y mod x, x]
			end repeat
		end GCD
	end script
	
	tell the result to foldItems from its array ¬
		at item 1 of its array ¬
		given handler:its GCD
end GCD:

# LCM:
#   Returns the lowest common multiple of a list of integers
on LCM:L
	local L
	
	script
		property array : L
		
		on GCD(x, y)
			local x, y
			
			repeat
				if x = 0 then return y
				set [x, y] to [y mod x, x]
			end repeat
		end GCD
		
		on LCM(x, y)
			local x, y
			
			set xy to x * y
			repeat
				if x = 0 then exit repeat
				set [x, y] to [y mod x, x]
			end repeat
			
			xy / y as integer
		end LCM
	end script
	
	tell the result to foldItems from its array ¬
		at item 1 of its array ¬
		given handler:its LCM
end LCM:

# floor()
#   Returns the greatest integer less than or equal to the supplied value
to floor(x)
	local x
	
	x - 0.5 + 1.0E-15 as integer
end floor

# ceil()
#   Returns the lowest integer greater than or equal to the supplied value
on ceil(x)
	local x
	
	floor(x) + 1
end ceil

# sqrt()
#   Returns the positive square root of a number
to sqrt(x)
	local x
	
	x ^ 0.5
end sqrt

# Roman()
#   Returns a number formatted as Roman numerals
on Roman(N as integer)
	local N
	
	script numerals
		property list : words of "I IV V IX X XL L XC C CD D CM M"
		property value : "1 4 5 9 10 40 50 90 100 400 500 900 1000"
		property string : {}
	end script
	
	
	repeat with i from length of list of numerals to 1 by -1
		set glyph to item i in the list of numerals
		set x to item i in the words of numerals's value
		
		make (N div x) at glyph
		set string of numerals to string of numerals & result
		set N to N mod x
	end repeat
	
	return the string of numerals as linked list as text
end Roman

# primes()
#   Generates a list of prime numbers less than or equal to the supplied value
on primes(N as integer)
	local N
	
	script primes
		property list : make N
	end script
	
	repeat with p from 2 to sqrt(N)
		if item p in the list of primes ≠ false then ¬
			repeat with i from 2 * p to N by p
				set item i in the list of primes to false
			end repeat
	end repeat
	
	return the rest of the numbers in the list of primes
end primes

# factorise()
#   Factorises an integer into a list of prime factors
to factorise(N as integer)
	local N
	
	script factors
		property list : {}
	end script
	
	repeat while N mod 2 = 0
		set end of list of factors to 2
		set N to N / 2
	end repeat
	
	repeat with i from 3 to sqrt(N) by 2
		repeat while N mod i = 0
			set end of list of factors to i
			set N to N / i
		end repeat
	end repeat
	
	if N > 2 then set end of list of factors to N as integer
	
	return the list of factors
end factorise

# factorial()
#   Calculates the factorial of a number
on factorial(N)
	if N = 0 then return 1
	N * (factorial(N - 1))
end factorial

# e()
#   Returns the value of the exponent raised to the supplied power (x)
on e(x)
	set L to make 16
	
	script
		on exp(y)
			script
				on fn(x)
					set N to x - 1
					(y ^ N) / (factorial(N))
				end fn
			end script
		end exp
	end script
	
	mapItems from L given handler:result's exp(x)
	my sum:result
end e

# sin()
#   Calculates the sine of a number
on sin(x)
	set L to make 19
	
	script
		on sin(y)
			script
				on fn(x, i)
					set N to i
					if N mod 2 = 0 then return 0
					set s to N mod 4
					if s = 3 then set s to -1
					s * (y ^ N) / (factorial(N))
				end fn
			end script
		end sin
	end script
	
	mapItems from L given handler:result's sin(x)
	set v to my sum:result
	if v < 1.0E-13 then set v to 0.0
	v
end sin

# cos()
#   Calculates the cosine of a number
on cos(x)
	set L to make 19
	
	script
		on cos(y)
			script
				on fn(x, i)
					set N to i - 1
					if N mod 2 = 1 then return 0
					set s to (N + 1) mod 4
					if s = 3 then set s to -1
					s * (y ^ N) / (factorial(N))
				end fn
			end script
		end cos
	end script
	
	mapItems from L given handler:result's cos(x)
	set v to my sum:result
	if v < 1.0E-13 then set v to 0.0
	v
end cos
---------------------------------------------------------------------------❮END❯