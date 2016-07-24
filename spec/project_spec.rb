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

	# Describe Roject#create
	#
	# Creates a file of the given type with the given args
	#
	# Parameter: type - the type of the file to make
	# Parameter: args - the args to pass to the file
	describe '#create' do
		before :all do
			@type    = :header
			@path    = "path/to/file"
			@outpath = "include/#{@project.project_name}/#{@path}.h"
			@outtext = IO.read("output/testheader.h")
		end

		it 'creates a file of the given type with the given arguments' do
			@project.create @type, path: @path, header_id: @project.c_header_id(@path)
			expect(File).to be_file(@outpath)
			expect(IO.read(@outpath)).to eql @outtext
		end
	end

	# Do afterwards
	after :all do
		FileUtils.rmtree(@project.directories)
	end
end