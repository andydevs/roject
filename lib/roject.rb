=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

# Available files
require_relative "project"

# Roject is a programming project manager written in Ruby.
#
# Author:  Anshul Kharbanda
# Created: 7 - 8 - 2016
module Roject
	# The Version of Roject
	VERSION = "0.6.0"

	# Returns true if the current directory has a project script
	#
	# Return: true if the current directory has a project script
	def self.project?; File.file?("project.rb"); end

	# Runs the maker in the current project with the given name and the given args
	#
	# Parameter: name - the name of the maker
	# Parameter: args - the args to pass to the maker
	def self.make(name, args); Project.load("project.rb").make(name, args); end
end