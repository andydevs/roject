=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

# Parser libraries
require "json"
require "yaml"

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
		# Subclasses must respond to :parse and :format methods
		# 	- parse recieves a string and returns a hash
		# 	- format recieves a hash and returns a string
		#
		# Author:  Anshul Kharbanda
		# Created: 7 - 11 - 2016
		class Parser
			# Matches parser class names
			PARSER_REGEX = /(Roject::)?(Parsers::)?(?<name>\w+)Parser/

			# Returns the descendants of Parser
			#
			# Return: the descendants of Parser
			def self.descendants
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
			def self.parse(text); JSON.parse text, symbolize_names: true; end

			# Returns the given hash formatted to pretty json
			#
			# Parameter: hash - the hash to format
			#
			# Return: the given hash formatted to pretty json
			def self.format(hash); JSON.pretty_generate hash, indent: "\t"; end
		end

		# Parses YAML files
		#
		# Author:  Anshul Kharbanda
		# Created: 7 - 13 - 2016
		class YAMLParser < Parser
			# Parses the given yaml text into a hash
			#
			# Parameter: text - the yaml text to parse
			#
			# Return: the hash parsed from the text
			def self.parse(text); symbolized YAML.load text; end

			# Returns the given hash formatted to yaml
			#
			# Parameter: hash - the hash to format
			#
			# Return: the given hash formatted to yaml
			def self.format(hash); YAML.dump stringified hash end

			private

			# Returns the hash with all of the keys converted to symbols
			#
			# Parameter: hash - the hash to symbolize
			#
			# Return: the hash with all of the keys converted to symbols
			def self.symbolized hash
				hash.each_pair.collect { |k, v| [k.to_sym, v.is_a?(Hash) ? symbolized(v) : v] }.to_h
			end

			# Returns the hash with all of the keys converted to strings
			#
			# Parameter: hash - the hash to stringify
			#
			# Return: the hash with all of the keys converted to strings
			def self.stringified hash
				hash.each_pair.collect { |k, v| [k.to_s,   v.is_a?(Hash) ? stringified(v) : v] }.to_h
			end
		end

		#-----------------------------------------GET------------------------------------------

		# Returns the parser for the given filename
		#
		# Parameter: filename - the name of the file to parse
		#
		# Return: the parser for the given filename
		def self.get(filename)
			# Get parser from filename
			parser = Parser.descendants.find do |klass| 
				klass.extension == File.extname(filename)
			end

			# Raise LoadError if parser is nil (extension is not supported)
			raise LoadError, "#{File.extname(filename)} not supported!" if parser.nil?

			# Otherwise return parser
			return parser
		end
	end
end