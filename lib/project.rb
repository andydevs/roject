=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

# Other modules
require_relative "loadsaveable"
require_relative "helpers"
require_relative "maker"

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
		# Includes
		include LoadSaveable
		include Helpers

		# Creates a Project with the given data hash
		#
		# Parameter: hash - the data to be contained in the project
		def initialize hash={}
			@project = hash
			@makers = {}
		end

		# Returns a hash of the data contained in the project
		#
		# Return: a hash of the data contained in the project
		def hash; @project; end

		# Attributes part of Project
		get :project_name,
			:author,
			:created,
			:short_description,
			:long_description,
			:directories

		# Loads the makers in the file with the given filename
		#
		# Parameter: filename - the name of the file to read
		def load_makers(filename); instance_eval(IO.read(filename)); end

		# Runs the maker of the given name with the given args
		#
		# Parameter: name - the name of the maker to run
		# Parameter: args - the args to pass to the file
		def make name, args
			@makers[name].make(self, args)
		end

		# Creates a file maker with the given name and hash
		#
		# Parameter: name - the name of the maker
		# Parameter: hash - the hash arguments of the maker
		def file name, hash
			@makers[name] = FileMaker.new(hash)
		end

		# Adds the recipie specified by the given name and block
		# to the makers table
		#
		# Parameter: name - the name of the recipie
		# Parameter: block - the recipie block
		#
		# Throw: RuntimeError - if the name is already defined as a filetype
		def task name, &block
			@makers[name] = TaskMaker.new &block
		end
	end
end