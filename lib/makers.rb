=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

# Libraries
require "general"
require "fileutils"

# Roject is a programming project manager written in Ruby.
#
# Author:  Anshul Kharbanda
# Created: 7 - 8 - 2016
module Roject
	# Runs a task with the given arguments
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 23 - 2016
	class TaskMaker
		# Initializes a TaskMaker with the given block
		#
		# Parameter: &block - the block to run on make
		def initialize(&block); @block = block; end

		# Runs the task with the given arguments
		#
		# Parameter: project - the project running the task
		# Parameter: args    - the args being used to run the task
		def make project, args
			project.instance_exec project.config.merge(args), &@block
		end
	end

	# Creates files according to the given credentials
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 21 - 2016
	class FileMaker
		# Read extension, directory, and template
		attr :extension, :directory, :template

		# Initializes a FileMaker from the given hash
		#
		# Parameter: hash - the hash to parse
		def initialize project, hash
			@path = General::GTemplate.new hash[:path]
			@template = General::GIO.load "#{project.config[:directory][:templates]}/#{hash[:template]}"
			@extension = hash[:extension]
		end

		# Creates a file of the filetype with the given args
		#
		# Parameter: project - the project running the task
		# Parameter: args    - the args being used to create the file
		def make project, args
			# merge args with project
			args.merge! project.config

			# Get path
			path = "#{@path.apply(args)}.#{@extension}"

			# Create directory
			dir = File.dirname(path)
			FileUtils.mkdir_p dir unless Dir.exist? dir

			# Write template to path
			@template.write(path, args)
		end
	end
end