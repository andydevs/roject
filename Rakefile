=begin 

Program: Roject

Roject is a programming project manager written in Ruby.
With Roject, you can create and edit projects based on templates
using simple commands without a heavy IDE.

Author:  Anshul Kharbanda
Created: 7 - 8 - 2016

=end

# Required libraries
require "rspec/core/rake_task"
require "rubygems/tasks"
require "fileutils"

# Requird files
require_relative "lib/roject"

# Directories
GEMDIR  = "gem"
SPECDIR = "spec"

# Test argument sets
TEST_ARG_SETS = "header path:\"path/to/file\"",
				"module path:\"path/to/second/file\""

# Default task
task :default => :spec

#----------------------------------RSPEC----------------------------------

RSpec::Core::RakeTask.new do |task|
	task.pattern    = "#{SPECDIR}/*_spec.rb"
	task.rspec_opts = "--format documentation --color"
end

#-----------------------------------GEM-----------------------------------

Gem::Tasks.new

#-----------------------------------GIT-----------------------------------

namespace :git do
	desc "Push changes to remote"
	task :push, [:message] => :commit do
		sh "git push origin master"
	end

	desc "Commit changes"
	task :commit, [:message] do |task, args|
		sh "git add --all"
		sh "git commit -m #{args[:message].inspect}"
	end

	desc "Soft git reset"
	task :reset do sh "git reset" end

	desc "Hard git reset"
	task :reset_hard do sh "git reset --hard HEAD" end
end

#----------------------------------SCRIPT----------------------------------

desc "Runs the script with test arguments"
task :test, [:index] do |task, args|
	# Changedown to project
	Dir.chdir "exp/project"

	# Run each test arg set
	sh "../../bin/roject #{TEST_ARG_SETS[args[:index].to_i]}"

	# Changeup
	Dir.chdir "../.."
end

desc "Cleans the project directory"
task :cleantest do
	# Changedown to project
	Dir.chdir "exp/project"
	
	# Cleanup
	FileUtils.rmtree ["include", "src"]

	# Changeup
	Dir.chdir "../.."
end