=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

require "json"

# Roject is a programming project manager written in Ruby.
#
# Author:  Anshul Kharbanda
# Created: 7 - 8 - 2016
module Roject
	# Contains implementations of parsers for different filetypes
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 11 - 2016
	module Parsers
		# Generic class parses files of a given type
		#
		# Subclasses must respond to :parse and :generate methods
		# 	- parse recieves a string and returns a hash
		# 	- generate recieves a hash and returns a string
		#
		# Author:  Anshul Kharbanda
		# Created: 7 - 11 - 2016
		class Parser
			# Matches parser class names
			PARSER_REGEX = /(Roject::)?(Parsers::)?(?<name>\w+)Parser/

			# Returns the descendants of Parser
			#
			# Return: the descendants of Parser
			def self.descendents
				ObjectSpace.each_object(Class).select {|c| c < self}
			end

			# Returns the extension name of the parser filetype
			#
			# Return: the extension name of the parser filetype
			def self.extension
				"." + PARSER_REGEX.match(self.name)[:name].downcase
			end
		end

		#---------------------------------------PARSERS---------------------------------------

		# Parses JSON files
		#
		# Author:  Anshul Kharbanda
		# Created: 7 - 11 - 2016
		class JSONParser < Parser
			# Parses the given json text into a hash
			#
			# Parameter: text - the json text to parse
			#
			# Return: the hash parsed from the text
			def self.parse(text); JSON.parse(text, symbolize_names: true); end

			# Returns the given hash formatted to pretty json
			#
			# Parameter: hash - the hash to format
			#
			# Return: the given hash formatted to pretty json
			def self.format(hash); JSON.pretty_generate(hash, indent: "\t"); end
		end

		#-----------------------------------------GET------------------------------------------

		# Returns the parser for the given filename
		#
		# Parameter: filename - the name of the file to parse
		#
		# Return: the parser for the given filename
		def self.get(filename)
			case File.extname(filename)
			when ".json" then return JSONParser
				
			# Raise error if extension is not supported
			else raise LoadError, "#{File.extname(filename)} not supported!" 
			end
		end
	end
end