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
require "yaml"

# Required files for spec
require_relative "../lib/parsers"
require_relative "../lib/project"
require_relative "../lib/loadsaveable"

#-----------------------HASHMOD METHODS------------------------

# Returns the hash with all of the keys converted to symbols
#
# Parameter: hash - the hash to symbolize
#
# Return: the hash with all of the keys converted to symbols
def symbolized hash
	hash.each_pair.collect { |k, v| [k.to_sym, v.is_a?(Hash) ? symbolized(v) : v] }.to_h
end

# Returns the hash with all of the keys converted to strings
#
# Parameter: hash - the hash to stringify
#
# Return: the hash with all of the keys converted to strings
def stringified hash
	hash.each_pair.collect { |k, v| [k.to_s,   v.is_a?(Hash) ? stringified(v) : v] }.to_h
end

#------------------------READER METHODS------------------------

# Reads JSON from the file with the given filename
#
# Parameter: filename - the name of the file to read
# 
# Return: hash parsed from JSON file
def read_json filename
	JSON.parse IO.read(filename), symbolize_names: true
end

# Reads YAML from the file with the given filename
#
# Parameter: filename - the name of the file to read
# 
# Return: hash parsed from YAML file
def read_yaml filename
	symbolized YAML.load IO.read(filename)
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

# Writes the given hash as YAML to the file with the 
# given filename
#
# Parameter: filename - the name of the file to write to
# Parameter: hash     - the hash to write
def write_yaml filename, hash
	IO.write filename, YAML.dump(stringified(hash))
end