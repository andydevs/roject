=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

# Loadsaveable
require_relative "loadsaveable"

# Roject is a programming project manager written in Ruby.
#
# Author:  Anshul Kharbanda
# Created: 7 - 8 - 2016
module Roject
	# Represents a programming project managed by Roject
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 10 - 2016
	class Project
		# Includes LoadSaveable
		include LoadSaveable

		# Creates a Project with the given data hash
		#
		# Parameter: hash - the data to be contained in the project
		def initialize hash={}
			@project = hash
		end

		def config hash
			@project = hash
		end

		# Returns a hash of the data contained in the project
		#
		# Return: a hash of the data contained in the project
		def hash
			@project
		end
	end
end