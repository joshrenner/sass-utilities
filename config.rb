# Environment - build for :developemnt or :production
# environment = :production
# Options - set deployment here
sass_options = {:debug_info => true, :custom => { :deployment => "BrandA" } }



# You shouldn't need to change anything below:

# Functions - can be called in the SASS files
# file_exists - determine if the file exists on disk
module Sass::Script::Functions 
	# Does the supplied image exist? 
	def file_exists(image_file) 
		path = Dir.getwd + "/" + image_file.value 
		Sass::Script::Bool.new(File.exists?(path)) 
	end 
end
# extension
module Sass::Script::Functions
	def get_extension(file)
		file = file.value.nil? ? "" : file.value
		ext = File.extname(file)[/\w+/]
		Sass::Script::String.new(ext)
	end
end
module Sass::Script::Functions
	def has_extension(file)
		ext = File.extname(file.value)
		Sass::Script::Bool.new(!ext.empty?)
	end
end
module Sass::Script::Functions
	def strip_extension(file)
		Sass::Script::String.new(file.value[/.*(?=\..+$)/])
	end
end
# deployment - get the path to the deployment branding
module Sass::Script::Functions
	def deployment
		brand = options[:custom][:deployment]
		Sass::Script::String.new("Deployments/#{brand}/assets")
	end
end
# does the same as above, but as a variable used below
deployment_dir = "Deployments/#{sass_options[:custom][:deployment]}/assets"

# Constants - all controlled by vars above
http_path = "/"
css_dir = deployment_dir
sass_dir = "#{deployment_dir}/sass"
add_import_path "Common/assets/sass"
images_dir = ""
output_style = (environment == :production) ? :compressed : :nested
