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

# Requird files
require_relative "lib/roject"

# Directories
GEMDIR  = "gem"
SPECDIR = "spec"

# Default task
task :default => "spec"

#----------------------------------RSPEC----------------------------------

RSpec::Core::RakeTask.new :spec do |task|
	task.pattern    = "#{SPECDIR}/*_spec.rb"
	task.rspec_opts = "--format documentation --color"
end

#-----------------------------------GEM-----------------------------------

Gem::Tasks.new

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
	task :reset do
		sh "git reset"
	end

	desc "Hard git reset"
	task :reset_hard do
		sh "git reset --hard HEAD"
	end
end