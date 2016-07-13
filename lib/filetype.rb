=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

require "general"

module Roject
	class Filetype
		def initialize hash
			@extension = hash[:extension]
			@directory = General::GTemplate.new hash[:directory]
			@template  = General::GIO.load hash[:template]
		end

		def create opts
			
		end
	end
end