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

# Describing Roject::Project
#
# Represents a programming project managed by Roject
#
# Author:  Anshul Kharbanda
# Created: 7 - 8 - 2016
describe Roject::Project do
	# Describing LoadSaveable include
	# 
	# Implementing objects can be loaded from and saved to files in
	# any of the supported data storage formats.
	#
	# Formats: json, yaml
	#
	# Note: Implementing objects must have a constructor with takes a single hash 
	# 		argument and respond to the :hash method which returns a hash of the 
	# 		data that needs to be saved 
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 10 - 2016
	describe 'include LoadSaveable' do
		include_examples "loadsaveable", Roject::Project
	end
end