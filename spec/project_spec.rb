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
	# Do before
	before :all do
	  Dir.chdir "exp/project"
	  @project = Roject::Project.load "project.yaml"
	end

	# Describe Roject::Project#load_recipies
	# 
	# Loads the recipies in the file with the given filename
	#
	# Parameter: filename - the name of the file to read
	describe '#load_recipies' do
		it 'reads a recipies file and evaluates it in the context of the Project' do
			expect { @project.load_makers("makers.rb") }.not_to raise_error
		end
	end

	# Describe Roject::Project#make
	#
	# Runs the maker of the given name with the given args
	#
	# Parameter: name - the name of the maker to run
	# Parameter: args - the args to pass to the file
	describe '#make' do
		before :all do
			@path = "path/to/file"

			@header = {
				type: :header,
				out: "include/#{@project.project_name}/#{@path}.h",
				text: IO.read("output/testheader.h")
			}

			@source = {
				type: :source,
				out: "src/#{@path}.cpp",
				text: IO.read("output/testsource.cpp")
			}
		end

		# Creating filetype
		context 'with a file maker name given' do
			it 'creates a file of the given type with the given arguments' do
				@project.make @header[:type], path: @path, header_id: @project.c_header_id(@path)
				expect(File).to be_file(@header[:out])
				expect(IO.read(@header[:out])).to eql @header[:text]
			end
		end

		# Performing task
		context 'with a task maker name given' do
			it 'performs the task of the given name with the given arguments' do
				@project.make :module, path: @path
				[@header, @source].each do |file|
					expect(File).to be_file(file[:out])
					expect(IO.read(file[:out])).to eql file[:text]
				end
			end
		end

		# Do afterwards
		after :each do FileUtils.rmtree(@project.directories) end
	end
end