# Header file
file :header, 
path: "include/@(project_name)/@(path)",
template: "templates/header.general",
extension: "h"

# Source file
file :source, 
path: "src/@(path)",
template: "templates/source.general",
extension: "cpp"

# Module includes a source and include
task :module do |args|
	# Add header id
	args[:header_id] = c_header_id(args[:path])

	# Create source and header
	make :header, args
	make :source, args
end