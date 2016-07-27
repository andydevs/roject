# Roject

Roject is a programming project manager written in Ruby. With Roject, you can create and edit projects based on templates and using simple, customisable commands without a heavy IDE.

## Table of Contents

 - [Project Script](#project-script)
 	- [Config](#config)
 	- [Makers](#makers)
 - [The Command Line](#the-command-line)

## Project Script

A Roject project is configured using a project script in a project directory, create a ruby script called "project.rb". This ruby script is evaluated in the context of a Roject project object and contains information about the project, the types of files that can be made, and the tasks that can be performed.

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

Projects are configured using the `config` method:

```ruby
config project_name: "Dre",
author: "Anshul Kharbanda",
created: "7 - 23 - 2016",
short_description: "Forgot about Dre.",
long_description: "Nowadays everybody wanna talk like" \
" they got somethin' to say but nothin' comes out" \
" when they move their lips just a bunch of gibberish" \
" and they all acting like they forgot about Dre."
```

This command should be passed a hash of project info keys, of which are the following:

|        Key        |            Description             |
|:-----------------:|:----------------------------------:|
|   project_name    |      the name of the project       |
|      author       |       the project's author         |
|      created      |  the date the project was created  |
| short_description | a short description of the project |
| long_description  | a long description of the project  |

There are also optional options to set. The `directory` key is a hash of essential directories. The `templates` key within the `directory` hash determines where project templates are located, and defaults to `_templates`. Of course, this can also be changed to your liking.

```ruby
config project_name: "Dre",
author: "Anshul Kharbanda",
created: "7 - 23 - 2016",
short_description: "Forgot about Dre.",
long_description: "Nowadays everybody wanna talk like" \
" they got somethin' to say but nothin' comes out" \
" when they move their lips just a bunch of gibberish" \
" and they all acting like they forgot about Dre.",
directory: {
	templates: "new-templates-dir"
}
```

### Makers

Project makers are also specified int the Project script. Makers are automated tasks that create new files. There are two types of makers to date.

#### File Makers

File makers are specified using the `file` method.

```ruby
file :header, 
path: "include/@(project_name)/@(path)",
template: "header.general",
extension: "h"
```

The `file` method is passed a name (used to call the maker via the command line arguments), and a hash of options, which should include the following:

|    Key    |                     Description                     |
|:---------:|:---------------------------------------------------:|
|   path    |     The path of the file, as a General template     |
| template  | The filename of the General template file to format |
| extension |                 The file extension                  |

#### Task Makers

Task makers are specified using the `task` method.

```ruby
# Module includes a source and include
task :module do |args|
	# Add header id
	args[:header_id] = c_header_id(args[:path])

	# Create source and header
	make :header, args
	make :source, args
end
```

The `task` method is passed the command line name and a block which is called when the task is called from the command line, which takes one hash of arguments parsed from the command line.

## The Command Line

The Roject library comes with the `roject` binary script, from which you call the project makers that were defined.

```
$ roject [maker name] [command line arguments]
```

Command line arguments are key-value pairs which follow the following pattern: `[key]:[value]`. The script will search the current directory for a project script, read it, and run the given maker in the context of the project.

---
Anshul Kharbanda