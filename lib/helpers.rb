=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

# Roject is a programming project manager written in Ruby.
#
# Author:  Anshul Kharbanda
# Created: 7 - 8 - 2016
module Roject
	# Helpers for Roject projects
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 8 - 2016
	module Helpers
		# Generates a c header id for the given path
		# this is an identifier used for checking if 
		# the header has been implemented
		# 
		# Parameters: path - the path being converted
		#
		# Return: a c header id generated from the given path
		def c_header_id(path); "_#{path.upcase.gsub(/\/|\\/, "_")}_H_"; end
	end
end