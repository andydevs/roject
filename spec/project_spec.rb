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
		# Change to project
		Dir.chdir "exp/project"

		# Create base project
		@project = Roject::Project.new

		# Foobar file
		@foofle = "foobar.rb"
		@foocfg = Roject::Project::CONFIG_DEFAULT.merge({
			project_name: 	   "Foo",
			author: 	  	   "Anshul Kharbanda",
			created: 		   "7 - 24 - 2016",
			short_description: "Foo bar",
			long_description:  "Foo bar baz joo jar jaz noo kar kaz"
		})

		# Project info
		@path   = "path/to/file"
		@config = @foocfg

		# ----------------------FILE MAKERS----------------------

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

		@makefile = {
			name:      :makefile,
			path:      "Makefile",
			template:  "makefile.general",
			extension: nil,
			out:       "Makefile",
			text:      IO.read("output/Makefile")
		}

		@main = {
			name:      :main,
			path:      "src/main",
			template:  "main.general",
			extension: "cpp",
			out:       "src/main.cpp",
			text:      IO.read("output/main.cpp")
		}

		# ----------------------TASK MAKERS----------------------

		@module = {
			name:  :module,
			block: Proc.new do |args|
				args[:header_id] = c_header_id(args[:path])
				make :header, args
				make :source, args
			end
		}

		@init = {
			name:  :init,
			block: Proc.new do |args|
				make :makefile
				make :main
			end
		}
	end

	# Describe Roject::Project::exist?
	#
	# Check if a project file exists in the current directory
	#
	# Parameter: filename - the filename to check
	# 						(defaults to the default filename)
	# 
	# Returns: true if the project file exists in the current 
	# 		   directory
	describe '::exist?' do
		it 'checks if the given project filename exists in the current directory' do
			expect(Roject::Project).to be_exist(@foofle)
		end

		it 'checks the default project filename if no filename is given' do
			expect(Roject::Project).to be_exist
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
		# Check when filename is given
		it 'loads a project from the given filename' do
			# Test loading foobar.rb file
			expect{@project = Roject::Project.load(@foofle)}.not_to raise_error
			expect(@project).to be_an_instance_of Roject::Project
			expect(@project.config).to eql @foocfg
		end

		# Check when filename is not given
		it 'loads a project from the default filename (if no filename is given)' do
			# Test loading default file
			expect{@project = Roject::Project.load}.not_to raise_error
			expect(@project).to be_an_instance_of Roject::Project
		end

		# Delete makers
		after :all do @project.instance_variable_set :@makers, {} end
	end

	# Describe Roject::Project::open
	# 
	# Alias for load if no block is given. Evaluates the given
	# block in the context of the project if block is given
	#
	# Parameter: filename - the name of the file to parse
	# 						(defaults to the default filename)
	# Parameter: block    - the block to evaluate within the 
	# 						context of the project
	# 
	# Return: Project loaded from the file
	describe '::open' do
		# Check for when no block is given
		it 'loads the project and returns it with no block given' do
			expect { @project = Roject::Project.open }.not_to raise_error
			expect(@project).to be_an_instance_of Roject::Project
		end

		# Check for when block is given
		it 'loads the project and evaluates in the context of the project (if block given)' do
			project = nil
			expect { Roject::Project.open { project = self } }.not_to raise_error
			expect(project).to be_an_instance_of Roject::Project
		end

		# Delete makers
		after :all do @project.instance_variable_set :@makers, {} end
	end

	# Describe Roject::Project#reload
	#
	# Reloads the project with the file with the given filename
	# 
	# Parameter: filename - the name of the file to parse
	# 						(defaults to the default filename)
	describe '#reload' do
		# Test loading foobar.rb file
		it 'loads the given filename into the project' do
			expect{@project.reload("foobar.rb")}.not_to raise_error
			expect(@project).to be_an_instance_of Roject::Project
			expect(@project.config).to eql @foocfg
		end

		# Test loading default file
		it 'loads the default filename (if no filename is given)' do
			expect{@project.reload}.not_to raise_error
			expect(@project).to be_an_instance_of Roject::Project
		end

		# Delete makers
		after :all do @project.instance_variable_set :@makers, {} end
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
		it 'returns the configuration of the Project with no arguments given' do
			expect(@project.config).to eql Roject::Project::CONFIG_DEFAULT
		end

		it 'configures the Project if a configuration hash is given' do
			expect{@project.config(@foocfg)}.not_to raise_error
			expect(@project.config).to eql @foocfg
		end
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
			[@header, @source, @makefile, @main].each do |ft|
				# Create filemaker
				@project.file ft[:name], ft
				fmkr = @project.instance_variable_get(:@makers)[ft[:name]]

				# Filemaker
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
			[@module, @init].each do |tk|
				# Create taskmaker
				@project.task tk[:name], &tk[:block]
				tmkr = @project.instance_variable_get(:@makers)[tk[:name]]

				# Check taskmaker
				expect(tmkr).to be_an_instance_of Roject::TaskMaker
			end
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
		it 'creates the given filetype with the given arguments if a file maker name is given' do
			# Each file type
			[@header, @source, @makefile, @main].each do |ft|
				# Make Header
				@project.make ft[:name], 
				path: @path,
				header_id: @project.c_header_id(@path)

				# Test output
				expect(File).to be_file(ft[:out])
				expect(IO.read(ft[:out])).to eql ft[:text]
			end
		end

		# Performing task
		it 'performs the given task with the given arguments if task maker name is given' do
			# Do module tasks
			@project.make @module[:name], path: @path

			# Each header
			[@header, @source].each do |file|
				# Test output
				expect(File).to be_file(file[:out])
				expect(IO.read(file[:out])).to eql file[:text]
			end
		end

		# Delete files
		after :all do 
			FileUtils.rmtree ["include", "src"]
			FileUtils.rm "Makefile"
		end
	end

	# Change back to root
	after :all do Dir.chdir "../.." end
end