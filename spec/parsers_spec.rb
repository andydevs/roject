=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

# Spec require
require_relative "spec_require"

# Describing Roject::Parsers
#
# Contains implementations of parsers for different filetypes
#
# Author:  Anshul Kharbanda
# Created: 7 - 11 - 2016
describe Roject::Parsers do
	#------------------------------------------BEFORE-------------------------------------------

	before :all do 
		@hash = { foo: "bar", baz: ["Ju", "Jay", "Jaz"] } 
	end

	#------------------------------------------PARSERS------------------------------------------

	# Describing Roject::Parsers::JSONParser
	#
	# Parses JSON files
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 11 - 2016
	describe '::JSONParser' do

		#----------------------------------BEFORE-----------------------------------

		before :all do 
			@text = JSON.pretty_generate(@hash, indent: "\t") 
			@parser = Roject::Parsers::JSONParser
		end

		#----------------------------------METHODS----------------------------------

		# Describing Roject::Parsers::JSONParser::parse
		#
		# Parses the given json text into a hash
		#
		# Parameter: text - the json text to parse
		#
		# Return: the hash parsed from the text
		describe '::parse' do
			it 'parses the given JSON text into a ruby hash' do
				expect(@parser.parse(@text)).to eql @hash
			end
		end

		# Describing Roject::Parsers::JSONParser::format
		#
		# Returns the object hash formatted to pretty json
		#
		# Parameter: hash - the hash to format
		#
		# Return: the given hash formatted to pretty json
		describe '::format' do
			it 'formats the given hash into pretty JSON' do
				expect(@parser.format(@hash)).to eql @text
			end
		end
	end

	#--------------------------------------------GET--------------------------------------------

	describe '::get' do
		it 'returns the appropriate parser according to the extension of the given filename' do
			expect(Roject::Parsers.get("foo.json")).to eql Roject::Parsers::JSONParser
		end
	end
end