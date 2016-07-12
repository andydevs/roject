=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

# Required libraries
require "json"

# Required files for spec
require_relative "../lib/parsers"
require_relative "../lib/project"

# Spec shared examples
require_relative "shared/loadsaveable_spec"

#------------------------READER METHODS------------------------

# Reads JSON from the file with the given filename
#
# Parameter: filename - the name of the file to read
# 
# Return: hash parsed from JSON file
def read_json filename
	JSON.parse IO.read(filename), symbolize_names: true
end

#------------------------WRITER METHODS------------------------

# Writes the given hash as JSON to the file with the 
# given filename
#
# Parameter: filename - the name of the file to write to
# Parameter: hash     - the hash to write
def write_json filename, hash
	IO.write filename, JSON.pretty_generate(hash, indent: "\t") 
end