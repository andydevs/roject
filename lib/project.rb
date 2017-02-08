=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

# Other modules
require_relative "helpers"
require_relative "makers"

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
		# Helper methods for creating and manipulating projects
		include Helpers

		# Default filename
		FILENAME_DEFAULT = "project.rb"

		# Default configuration
		CONFIG_DEFAULT = {
			project_name: "[project-name]",
			author: "[author]",
			created: "[created]",
			short_description: "[short_description]",
			long_description: "[long_description]",
			directory: {
				templates: "_templates"
			}
		}

		# Check if a project file exists in the current directory
		#
		# Parameter: filename - the filename to check
		# 						(defaults to the default filename)
		# 
		# Returns: true if the project file exists in the current 
		# 		   directory
		def self.exist? filename=FILENAME_DEFAULT
			File.file?(FILENAME_DEFAULT)
		end

		#-----------------------------------CLASS CONFIG-----------------------------------

		# Alias for load if no block is given. Evaluates the given
		# block in the context of the project if block is given
		#
		# Parameter: filename - the name of the file to parse
		# 						(defaults to the default filename)
		# Parameter: block    - the block to evaluate within the 
		# 						context of the project
		# 
		# Return: Project loaded from the file
		def self.open filename=FILENAME_DEFAULT, &block
			project = self.load(filename)
			project.instance_eval(&block) unless block.nil?
			return project
		end

		# Loads a Project from the project file with the given filename
		# 
		# Parameter: filename - the name of the file to parse
		# 						(defaults to the default filename)
		#
		# Return: Project loaded from the file
		def self.load filename=FILENAME_DEFAULT
			project = self.new
			project.instance_eval(IO.read(filename))
			return project
		end

		#----------------------------------INSTANCE CONFIG----------------------------------

		# Called upon the initialization of a Project
		# Creates config and makers hashes
		def initialize; @config = CONFIG_DEFAULT; @makers = {}; end

		# Reloads the project with the file with the given filename
		# 
		# Parameter: filename - the name of the file to parse
		# 						(defaults to the default filename)
		def reload(filename=FILENAME_DEFAULT); initialize and instance_eval(IO.read(filename)); end

		# If a hash is given, sets the Project configuration to the hash.
		# Else, returns the configuration of the Project.
		#
		# Parameter: hash - the hash to configure the project with
		#
		# Return: the configuration of the Project
		def config(hash=nil); hash and @config.merge!(hash) or return @config; end

		#-------------------------------------MAKERS-----------------------------------------

		# Runs the maker of the given name with the given args
		#
		# Parameter: name - the name of the maker to run
		# Parameter: args - the args to pass to the file
		def make name, args={}
			if @makers.has_key? name
				@makers[name].make self, args
			else
				raise RuntimeError, "Undefied maker #{name}"
			end
		end

		# Creates a file maker with the given name and hash
		#
		# Parameter: name - the name of the maker
		# Parameter: hash - the hash arguments of the maker
		def file(name, hash)
			unless @makers.has_key? name
				@makers[name] = FileMaker.new self, hash
			end
		end

		# Creates a task maker with the given name and block
		#
		# Parameter: name - the name of the recipie
		# Parameter: block - the recipie block
		def task(name, &block);
			unless @makers.has_key? name
				@makers[name] = TaskMaker.new &block
			end
		end
	end
end