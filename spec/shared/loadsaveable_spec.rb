=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

# Describing loadsaveable_class
#
# Implementing objects can be loaded from and saved to files in
# any of the supported data storage formats.
#
# Formats: json
#
# Note: Implementing objects need to respond to the :hash method
# 		which returns a hash of the data that needs to be saved
#
# Author:  Anshul Kharbanda
# Created: 7 - 11 - 2016
shared_examples "loadsaveable" do |loadsaveable_class|
	#---------------------------------------BEFORE----------------------------------------

	before :all do
		@dir = "exp/loadsaveable"
		@default_hash = { name: "project" }
		@modded_hash = { name: "superproject", author: "Anshul Kharbanda" }
		@pjson_name = "#{@dir}/foo.json"
		@pyaml_name = "#{@dir}/foo.yaml"
		@phony_name = "#{@dir}/foo.bar"
	end

	#--------------------------------------METHODS-----------------------------------------

	# Describing LoadSaveable::new
	#
	# Creates a LoadSaveable with the given data hash
	#
	# Parameter: hash - the data to be contained in the project
	#
	# Return: the created LoadSaveable
	describe "::new" do
		context "with no arguments" do
			it "creates an empty #{loadsaveable_class.name}" do
				project = loadsaveable_class.new
				expect(project).to be_an_instance_of loadsaveable_class
				expect(project.hash).to eql Hash.new
			end
		end

		context "with a given data hash" do
			it "creates a new #{loadsaveable_class.name} with the given data hash" do
				project = loadsaveable_class.new @default_hash
				expect(project).to be_an_instance_of loadsaveable_class
				expect(project.hash).to eql @default_hash
			end
		end
	end

	# Describing LoadSaveable::load
	#
	# Loads an object from a file of the given filename, parsed
	# in the appropriate format based on the extension
	#
	# Parameter: filename - the name of the file
	#
	# Return: object loaded from the file
	describe "::load" do
		#------------------------------FILETYPES------------------------------

		context "with a .json filename given" do
			it "returns a new #{loadsaveable_class.name} from the json file with the given filename" do
				project = loadsaveable_class.load(@pjson_name)
				expect(project).to be_an_instance_of loadsaveable_class
				expect(project.hash).to eql read_json(@pjson_name)
			end
		end

		context "with a .yaml filename given" do
			it "returns a new #{loadsaveable_class.name} from the yaml file with the given filename" do
				project = loadsaveable_class.load(@pyaml_name)
				expect(project).to be_an_instance_of loadsaveable_class
				expect(project.hash).to eql read_yaml(@pyaml_name)
			end
		end

		#-----------------------------UNSUPPORTED-----------------------------

		context "with an unsupported file extension given" do
			it "raises LoadError" do
				expect { loadsaveable_class.load(@phony_name) }.to raise_error LoadError
			end
		end
	end

	# Describing LoadSaveable#save
	#
	# Saves the object at the given filename, formatted according 
	# to the extension
	#
	# Parameter: filename - the name of the file to save to
	# 						(opened in w+ mode). Extension
	# 						determines format
	describe "#save" do
		#-------------------------------BEFORE--------------------------------

		before :each do 
			@project = loadsaveable_class.new @modded_hash 
		end

		#------------------------------FILETYPES------------------------------

		context "with a .json filename given" do
			it "saves the project to the given filename in json format" do
				@project.save @pjson_name
				expect(read_json(@pjson_name)).to eql @modded_hash
			end
		end

		context "with a .yaml filename given" do
			it "saves the project to the given filename in yaml format" do
				@project.save @pyaml_name
				expect(read_yaml(@pyaml_name)).to eql @modded_hash
			end
		end

		#-----------------------------UNSUPPORTED-----------------------------

		context "with an unsupported file extension given" do
			it "raises LoadError" do
				expect { @project.save @phony_name }.to raise_error LoadError
			end
		end

		#-------------------------------AFTER--------------------------------

		after :all do 
			write_json @pjson_name, @default_hash
			write_yaml @pyaml_name, @default_hash
		end
	end

	# Describing LoadSaveable::open
	#
	# Opens the object from a file, evaluates the given 
	# block in the context of the object, and saves the object. 
	# If no block is given, returns the object (alias for load)
	#
	# Parameter: filename - the name of the file to open
	# Parameter: block    - the block to evaluate within the 
	# 						context of the object
	#
	# Return: the object loaded from the file (if no block given)
	describe "::open" do
		context "with filename and block given" do
			#------------------------------FILETYPES------------------------------

			context "when file is .json" do
				# Declare project local variable
				project = nil

				it "loads a #{loadsaveable_class.name} from the json file with the given filename (calling #load)" do
					# Declare modded_hash local variable
					mhash = @modded_hash

					# Open project in a block
					expect { loadsaveable_class.open @pjson_name do
						# Set project to instance
						project = self

						# Modify project
						config mhash
					end }.not_to raise_error
				end

				it "evaluates the given block in the context of the loaded #{loadsaveable_class.name}" do
					# Check if project was actually self, and it was successfuly modified
					expect(project).to be_an_instance_of loadsaveable_class
					expect(project.hash).to eql @modded_hash
				end

				it "saves the #{loadsaveable_class.name} when the block ends" do
					# Check if the modded project was saved
					expect(read_json(@pjson_name)).to eql @modded_hash
				end
			end

			context "when file is .yaml" do
				# Declare project local variable
				project = nil

				it "loads a #{loadsaveable_class.name} from the yaml file with the given filename (calling #load)" do
					# Declare modded_hash local variable
					mhash = @modded_hash

					# Open project in a block
					expect { loadsaveable_class.open @pyaml_name do
						# Set project to instance
						project = self

						# Modify project
						config mhash
					end }.not_to raise_error
				end

				it "evaluates the given block in the context of the loaded #{loadsaveable_class.name}" do
					# Check if project was actually self, and it was successfuly modified
					expect(project).to be_an_instance_of loadsaveable_class
					expect(project.hash).to eql @modded_hash
				end

				it "saves the #{loadsaveable_class.name} when the block ends" do
					# Check if the modded project was saved
					expect(read_yaml(@pyaml_name)).to eql @modded_hash
				end
			end

			#-----------------------------UNSUPPORTED-----------------------------

			context "when filetype is unsupported" do
				it "raises LoadError" do
					expect { loadsaveable_class.open(@phony_name) {} }.to raise_error LoadError
				end
			end

			after :all do 
				write_json @pjson_name, @default_hash
				write_yaml @pyaml_name, @default_hash
			end
		end

		context "with filename given and no block given" do
			#------------------------------FILETYPES------------------------------

			context "when file is .json" do
				it "loads a #{loadsaveable_class.name} from the json file with the given filename (calling #load) and returns it." do
					project = loadsaveable_class.open @pjson_name
					expect(project).to be_an_instance_of loadsaveable_class
					expect(project.hash).to eql @default_hash
				end
			end

			context "when file is .yaml" do
				it "loads a #{loadsaveable_class.name} from the yaml file with the given filename (calling #load) and returns it." do
					project = loadsaveable_class.open @pyaml_name
					expect(project).to be_an_instance_of loadsaveable_class
					expect(project.hash).to eql @default_hash
				end
			end

			#-----------------------------UNSUPPORTED-----------------------------

			context "when filetype is unsupported" do
				it "raises LoadError" do
					expect { loadsaveable_class.open @phony_name }.to raise_error LoadError
				end
			end
		end
	end
end