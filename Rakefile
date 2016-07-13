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

# Requird files
require_relative "lib/roject"

# Directories
GEMDIR  = "gem"
SPECDIR = "spec"

#----------------------------------RSPEC----------------------------------

RSpec::Core::RakeTask.new :spec do |task|
	task.pattern    = "#{SPECDIR}/*_spec.rb"
	task.rspec_opts = "--format documentation", 
					  "--color"
end

#-----------------------------------GEM-----------------------------------

namespace :gem do
	
	#----------------------------------GEM CLEAR TASKS----------------------------------

	namespace :clear do
		desc "Clear all gems"
		task :all do
			sh "rm #{GEMDIR}/*.gem"	
		end

		desc "Clear old gems"
		task :old do
			sh "rm #{FileList.new("#{GEMDIR}/*.gem")
							 .exclude("#{GEMDIR}/roject-#{Roject::VERSION}.gem")}"
		end
	end

	#----------------------------------GEM BUILD TASKS----------------------------------

	desc "Build gem and push to Rubygems"
	task :push => "#{GEMDIR}/roject-#{Roject::VERSION}.gem" do |task|
		sh "gem push #{task.source}"
	end

	desc "Build gem and install locally"
	task :install => "#{GEMDIR}/roject-#{Roject::VERSION}.gem" do |task|
		sh "gem install #{task.source}"
	end

	desc "Just buid gem"
	task :build => "#{GEMDIR}/roject-#{Roject::VERSION}.gem"

	#-------------------------------BUILD GEM FROM GEMSPEC------------------------------

	file "#{GEMDIR}/roject-#{Roject::VERSION}.gem" => "roject.gemspec" do |task|
		sh "gem build #{task.source}"
		sh "mv #{File.basename(task.name)} #{File.dirname(task.name)}"
	end
end

# Default spec
task :default => "spec"