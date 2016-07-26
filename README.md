# Roject

Roject is a programming project manager written in Ruby. With Roject, you can create and edit projects based on templates and using simple, customisable commands without a heavy IDE.

## Project Script

A Roject project is configured using a project script in a project directory, create a ruby script called "project.rb". This ruby script is evaluated in the context of a Roject project object and contains information about the project, the types of files that can be made, and the tasks that can be performed. Here's an example of a project script:

```ruby
# Config
config project_name: "Dre",
author: "Anshul Kharbanda",
created: "7 - 23 - 2016",
short_description: "Forgot about Dre.",
long_description: "Nowadays everybody wanna talk like" \
" they got somethin' to say but nothin' comes out" \
" when they move their lips just a bunch of gibberish" \
" and they all acting like they forgot about Dre."

#---------------------------MAKERS---------------------------

# Header file
file :header, 
path: "include/@(project_name)/@(path)",
template: "header.general",
extension: "h"

# Source file
file :source, 
path: "src/@(path)",
template: "source.general",
extension: "cpp"

# Module includes a source and include
task :module do |args|
	# Add header id
	args[:header_id] = c_header_id(args[:path])

	# Create source and header
	make :header, args
	make :source, args
end
```

In this script, the project information (project_name, author, etc.) is configured using the `config` method, which is given a hash of the project info. After which, project makers (automated tasks that can be called via the command line) are defined using the `file` and `task` methods. The `file` method creates a file maker which makes files according to the information given using the command line arguments. The `task` method creates a task maker which executes the given block with the command line arguments.

### Config

Projects are configured using the `config` command.