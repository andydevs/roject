=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end
require_relative "../lib/roject"

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
		@project = Roject::Project.new
		@config = Roject::Project::CONFIG_DEFAULT.merge({
			project_name: 	   "Foo",
			author: 	  	   "Anshul Kharbanda",
			created: 		   "7 - 24 - 2016",
			short_description: "Foo bar",
			long_description:  "Foo bar baz ju lar laz nu kar kaz"
		})
	end

	# Describe Roject::Project#config
	#
	# If a hash is given, sets the Project configuration to the hash.
	# Else, returns the configuration of the Project.
	# 
	# Parameter: hash - the hash to configure the project with
	# 
	# Return: the configuration of the Project
	describe '#config' do
		context 'with no arguments given' do
			it 'returns the configuration of the Project' do
				expect(@project.config).to eql Roject::Project::CONFIG_DEFAULT
			end
		end

		context 'with hash given' do
			it 'configures the Project with the given hash' do
				expect{@project.config(@config)}.not_to raise_error
				expect(@project.config).to eql @config
			end
		end
	end

	# Describe Roject::Project::load
	#
	# Loads a Project from the project file with the given filename
	# 
	# Parameter: filename - the name of the file to parse
	#
	# Return: Project loaded from the file
	describe '::load' do
		context 'with a filename given' do
			it 'loads a project from the given filename' do
				expect{@project = Roject::Project.load("project.rb")}.not_to raise_error
				expect(@project).to be_an_instance_of Roject::Project
			end
		end

		context 'with no filename given' do
			it 'loads a project from the default filename' do
				expect{@project = Roject::Project.load}.not_to raise_error
				expect(@project).to be_an_instance_of Roject::Project
			end
		end

		after :all do
			@project.instance_variable_set :@makers, {}
		end
	end

	# Describe Roject::Project makers
	#
	# The system of automating tasks in Roject
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 24 - 2016
	describe 'makers' do
		# Before all
		before :all do
			@path = "path/to/file"
			@config = @project.config

			# ----------------------FILE INFO----------------------

			@header = {
				name:      :header,
				path:      "include/@(project_name)/@(path)",
				template:  "header.general",
				extension: "h",
				out:       "include/#{@config[:project_name]}/#{@path}.h",
				text:      IO.read("output/testheader.h")
			}

			@source = {
				name:      :source,
				path:      "src/@(path)",
				template:  "source.general",
				extension: "cpp",
				out:       "src/#{@path}.cpp",
				text:      IO.read("output/testsource.cpp")
			}

			# ----------------------TASK INFO----------------------

			@module = {
				name:  :module,
				block: Proc.new do |args|
					args[:header_id] = c_header_id(args[:path])
					make :header, args
					make :source, args
				end
			}
		end

		# Describe Roject::Project#file
		#
		# Creates a file maker with the given name and hash
		#
		# Parameter: name - the name of the maker
		# Parameter: hash - the hash arguments of the maker
		describe '#file' do
			it 'creates a file maker with the given name and hash of arguments' do
				# Each file type
				[@header, @source].each do |ft|
					# Create filemaker
					@project.file ft[:name], ft

					# Get Filemaker
					fmkr = @project.instance_variable_get(:@makers)[ft[:name]]
					expect(fmkr).to be_an_instance_of Roject::FileMaker

					# Path
					expect(fmkr.instance_variable_get(:@path)).to be_an_instance_of General::GTemplate
					expect(fmkr.instance_variable_get(:@path).to_s).to eql ft[:path]

					# Template
					expect(fmkr.instance_variable_get(:@template)).to be_an_instance_of General::GIO
					expect(fmkr.instance_variable_get(:@template).source).to eql "#{@config[:directory][:templates]}/#{ft[:template]}"

					# Extension
					expect(fmkr.instance_variable_get(:@extension)).to eql ft[:extension]
				end
			end
		end

		# Describe Roject::Project#task
		#
		# Creates a task maker with the given name and block
		#
		# Parameter: name - the name of the recipie
		# Parameter: block - the recipie block
		describe '#task' do
			it 'creates a task maker with the given name and block' do
				# Create taskmaker
				@project.task @module[:name], &@module[:block]

				# Get filemaker
				tmkr = @project.instance_variable_get(:@makers)[@module[:name]]
				expect(tmkr).to be_an_instance_of Roject::TaskMaker
			end
		end

		# Describe Roject::Project#make
		#
		# Runs the maker of the given name with the given args
		#
		# Parameter: name - the name of the maker to run
		# Parameter: args - the args to pass to the file
		describe '#make' do
			# Creating filetype
			context 'with a file maker name given' do
				it 'creates a file of the given type with the given arguments' do
					# Each file type
					[@header, @source].each do |ft|
						# Make Header
						@project.make ft[:name], 
						path: @path,
						header_id: @project.c_header_id(@path)

						# Test output
						expect(File).to be_file(ft[:out])
						expect(IO.read(ft[:out])).to eql ft[:text]
					end
				end
			end

			# Performing task
			context 'with a task maker name given' do
				it 'performs the task of the given name with the given arguments' do
					# Do task
					@project.make @module[:name], path: @path

					# Each header
					[@header, @source].each do |file|
						# Test output
						expect(File).to be_file(file[:out])
						expect(IO.read(file[:out])).to eql file[:text]
					end
				end
			end

			# Do afterwards
			after :each do FileUtils.rmtree ["include", "src"] end
		end
	end

	after :all do Dir.chdir "../.." end
end