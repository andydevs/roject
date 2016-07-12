=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

Gem::Specification.new do |spec|
	spec.name        = "roject"
	spec.version     = "0.1.0"
	spec.license     = "GPL-3.0"
	spec.summary     = "Roject is a programming project manager written in Ruby."
	spec.description = "Roject is a programming project manager written in Ruby. With Roject, " \
					   "you can create and edit projects based on templates using simple commands " \
					   "without a heavy IDE."
	spec.authors     = ["Anshul Kharbanda"]
	spec.email       = "akanshul97@gmail.com"

	# Dependencies
	spec.add_dependency "general",   ">1.3.0"
	spec.add_dependency "json",      ">1.8.3"
	spec.add_dependency "multi_xml", ">0.5.5"

	# Development dependiencies
	spec.add_development_dependency "rspec", ">3.4.4"

	#Files
	spec.files = Dir.glob("lib/**/*.*") \
			   + Dir.glob("spec/**/*.*") \
			   + Dir.glob("exp/**/*.*") \
			   + ["LICENSE", "README.md"]
end