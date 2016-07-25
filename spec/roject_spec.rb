=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end
require_relative "../lib/roject"

# Describing Roject
#
# Roject is a programming project manager written in Ruby.
#
# Author:  Anshul Kharbanda
# Created: 7 - 8 - 2016
describe Roject do
	# Describe Roject project
	#
	# Tasks for projects
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 24 - 2016
	describe 'project' do
		# Change to project
		before :all do Dir.chdir "exp/project" end

		# Describe Roject::project?
		#
		# Returns true if the current directory has a project script
		#
		# Return: true if the current directory has a project script
		describe '::project?' do
			it 'returns true if the current directory has a project script' do
				expect(Roject).to be_project
			end
		end

		# Describe Roject::make
		#
		# Runs the maker in the current project with the given name and the given args
		#
		# Parameter: name - the name of the maker
		# Parameter: args - the args to pass to the maker
		describe '::make' do
			# Before all
			before :all do
				# Get config (in this terribly disorganised way)
				@config = Roject::Project.load("project.rb").config

				# ----------------------FILE INFO----------------------

				# Path
				@path = "path/to/file"

				# Header file type
				@header = {
					name: :header,
					path: "include/@(project_name)/@(path)",
					template: "header.general",
					extension: "h",
					out: "include/#{@config[:project_name]}/#{@path}.h",
					text: IO.read("output/testheader.h")
				}

				# Source file type
				@source = {
					name: :source,
					path: "src/@(path)",
					template: "source.general",
					extension: "cpp",
					out: "src/#{@path}.cpp",
					text: IO.read("output/testsource.cpp")
				}

				# ----------------------TASK INFO----------------------

				# Module
				@module = {
					name: :module,
					block: Proc.new do |args|
						args[:header_id] = c_header_id(args[:path])

						make :header, args
						make :source, args
					end
				}
			end

			# Test
			it 'runs the maker in the current project with the given name and the given args' do
				# Make module
				Roject.make @module[:name], path: @path

				# Each filetype
				[@header, @source].each do |ft|
					# Test output
					expect(File).to be_file(ft[:out])
					expect(IO.read(ft[:out])).to eql ft[:text]
				end
			end

			# Do afterwards
			after :all do FileUtils.rmtree ["include", "src"] end
		end

		# Change back to root
		after :all do Dir.chdir "../.." end
	end
end