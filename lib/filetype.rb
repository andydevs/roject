=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

# General templating gem
require "general"
require "fileutils"

# Roject is a programming project manager written in Ruby.
#
# Author:  Anshul Kharbanda
# Created: 7 - 8 - 2016
module Roject
	# A template for files in a Project
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 21 - 2016
	class FileType
		# Read extension, directory, and template
		attr :extension, :directory, :template

		# Initializes a FileType from the given hash
		#
		# Parameter: hash - the hash to parse
		def initialize hash
			@path = General::GTemplate.new hash[:path]
			@template = General::GIO.load hash[:template]
			@extension = hash[:extension]
		end

		# Makes a file of this FileType with the given args
		#
		# Parameter: args - the args to pass to create
		def make args
			# Get path
			path = "#{@path.apply(args)}.#{@extension}"

			# Create directory
			dir = File.dirname(path)
			FileUtils.mkdir_p dir unless Dir.exist? dir

			# Write template to path
			@template.write(path, args)
		end

		# Returns a hash of the data stored in the FileType
		#
		# Return: a hash of the data stored in the FileType
		def hash
			{ path: @path.to_s,
			 template: @template.source,
			 extension: @extension }
		end
	end
end