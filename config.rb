# Environment - build for :developemnt or :production
# environment = :production
# Options - set deployment here
sass_options = {
	:debug_info => true, 
	:custom => { 
		:deployment => "imageFuncTest",
		:paths => {
			:deployment => "deployments/{deployment}/assets",
			:global => "common/assets"
		},
		:nunchi => {
			:image => ["[global]/img", "[deployment]/img"]
		}
	} 
}



# You shouldn't need to change anything below:
sass_options[:custom][:paths][:deployment]["{deployment}"]= sass_options[:custom][:deployment]
def subs(string)
	start = string.index '['
	stop = string.index ']'
	path = string[start + 1..stop - 1]
	return string[start..stop]= sass_options[:custom][:paths][path.to_sym]
end
def find_depl(array)
	newArr = []
	#array.each { |path| path.include? '[' ? newArr.push(subs(path)) : newArr.push(path) }
	return ["[global]/img", "[deployment]/img"]
end
sass_options[:custom][:nunchi][:image] = find_depl(sass_options[:custom][:nunchi][:image])
module Sass::Script::Functions
	def nunchi
		path = options[:custom][:nunchi][:image].children
		Sass::Script::List.new(path, :comma)
	end
end



# Functions - can be called in the SASS files
# file_exists - determine if the file exists on disk
module Sass::Script::Functions 
	# Does the supplied image exist? 
	def file_exists(file) 
		path = Dir.getwd + "/" + file.value 
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
deployment = sass_options[:custom][:paths][:deployment]
module Sass::Script::Functions
	def deployment
		path = options[:custom][:paths][:deployment]
		Sass::Script::String.new(path)
	end
end
global = sass_options[:custom][:paths][:global]
module Sass::Script::Functions
	def global
		path = options[:custom][:paths][:global]
		Sass::Script::String.new(path)
	end
end


# Constants - all controlled by vars above
http_path = "/"
css_dir = "#{deployment}/css"
sass_dir = "#{deployment}/sass"
add_import_path "#{global}/sass"
images_dir = ""
output_style = (environment == :production) ? :compressed : :nested

