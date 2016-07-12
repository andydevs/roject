=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

# Parsers
require_relative "parsers"

# Roject is a programming project manager written in Ruby.
#
# Author:  Anshul Kharbanda
# Created: 7 - 8 - 2016
module Roject
	# Implementing objects can be loaded from and saved to files in
	# any of the supported data storage formats.
	#
	# Formats: json, yaml
	#
	# Note: Implementing objects need to respond to the :hash method
	# 		which returns a hash of the data that needs to be saved
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 10 - 2016
	module LoadSaveable
		# Methods that are implemented at the class level
		#
		# Author:  Anshul Kharbanda
		# Created: 7 - 10 - 2016
		module ClassMethods
			# Opens the object from a file, evaluates the given 
			# block in the context of the object, and saves the object. 
			# If no block is given, returns the object (alias for load)
			#
			# Parameter: filename - the name of the file to open
			# Parameter: block    - the block to evaluate within the 
			# 						context of the object
			#
			# Return: the object loaded from the file (if no block given)
			def open filename, &block
				obj = load(filename)
				if block.nil?
					return obj
				else
					obj.instance_exec(&block)
					obj.save(filename)
				end
			end

			# Loads an object from a file of the given filename, parsed
			# in the appropriate format based on the extension
			#
			# Parameter: filename - the name of the file
			#
			# Return: object loaded from the file
			def load filename
				self.new Parsers.get(filename).parse IO.read filename
			end
		end

		# Methods that are implemented at the instance level
		#
		# Author:  Anshul Kharbanda
		# Created: 7 - 10 - 2016		
		module InstanceMethods
			# Saves the object at the given filename, formatted according 
			# to the extension
			#
			# Parameter: filename - the name of the file to save to
			# 						(opened in w+ mode). Extension
			# 						determines format
			def save filename
				IO.write filename, Parsers.get(filename).format(hash)
			end
		end
		
		# The implementing reciever will extend ClassMethods
		# and include InstanceMethods
		#
		# Parameter: reciever - the object being included
		def self.included(receiver)
			receiver.extend         ClassMethods
			receiver.send :include, InstanceMethods
		end
	end
end