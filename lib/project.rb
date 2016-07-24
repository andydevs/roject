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
require_relative "filetype"

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

		# The key that stores filetypes
		FILETYPES_KEY = :filetypes

		# Creates a Project with the given data hash
		#
		# Parameter: hash - the data to be contained in the project
		def initialize hash={}
			@project = hash.each_pair.select{|k,v| k != FILETYPES_KEY}.to_h
			@filetypes = hash[FILETYPES_KEY].each_pair.collect{|k,v|[k, FileType.new(v)]}.to_h
		end

		# Returns a hash of the data contained in the project
		#
		# Return: a hash of the data contained in the project
		def hash
			@project.merge(@filetypes.each_pair.collect{|k,v|[k,v.hash]}.to_h)
		end

		# Attributes part of Project
		get :project_name,
			:author,
			:created,
			:short_description,
			:long_description,
			:directories,
			:filetypes

		# Creates a file of the given type with the given args
		def create type, args
			@filetypes[type].make @project.merge args
		end
	end
end