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
		# Includes
		include Helpers

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

		# Loads a Project from the project file with the given filename
		# 
		# Parameter: filename - the name of the file to parse
		#
		# Return: Project loaded from the file
		def self.load filename
			project = Roject::Project.new
			project.instance_eval(IO.read(filename))
			return project
		end

		#----------------------------------INIT AND CONFIG----------------------------------

		# Called upon the initialization of a Project
		# Creates config and makers hashes
		def initialize; @config = CONFIG_DEFAULT; @makers = {}; end

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
		def make(name, args)
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