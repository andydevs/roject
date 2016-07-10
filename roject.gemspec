Gem::Specification.new do |spec|
	spec.name        = "roject"
	spec.version     = "0.0.0"
	spec.license     = "GPL-3.0"
	spec.summary     = "Roject is a programming project manager written in Ruby. " \
					   "With Roject, you can create and edit projects based on templates " \
					   "using simple commands without a heavy IDE."
	spec.description = "Roject is a programming project manager written in Ruby. With Roject, " \
					   "you can create and edit projects based on templates using simple commands " \
					   "without a heavy IDE."
	spec.authors     = ["Anshul Kharbanda"]
	spec.email       = "akanshul97@gmail.com"

	# Dependencies
	spec.add_dependency 			"general", "^1.2.8"
	spec.add_development_dependency "rspec",   "^3.4.4"

	#Files
	spec.files       = []
end