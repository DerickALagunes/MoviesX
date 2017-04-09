
require 'mongo'
require 'optparse'
require 'ostruct'
require 'base64'
require 'catpix'
require 'open-uri'

#validators
class String
  def validate regex
    !self[regex].nil?
  end
end

validateDate   = /^\D*(\d\d\d\d)\D+(\d\d?)\D+(\d\d?)\D*$/
validateString = /\A[a-zA-Z0-9@#\*\$\^\(\)_\+\-=,\.\?: !áéíóúÁÉÍÓÚ]+\z/
validateNumber = /^\d+$/
validateText   = /\A[a-zA-Z0-9@#\*\$\^\(\)_\+\-=,\.\?: \n!áéíóúÁÉÍÓÚ]+\z/


#Parse parameters
param = OpenStruct.new
OptionParser.new do |opt|
        opt.banner = "Usage:ruby moviesx.rb [options]\n\n"
        opt.on('-c', '--create', 'This option is used to prompt the creation of a new register') { |o| param.create = o }
        opt.on('-r', '--read',   'This option is used to get the information of the movies')     { |o| param.read = o }
        opt.on('-u', '--update Movie name [String]', 'Prompts the update function of a movie')   { |o| param.update = o }
        opt.on('-d', '--delete Movie name [String]', 'Prompts the delete function of a movie')   { |o| param.delete = o }
        opt.on('-i', '--image Movie poster, path to image file [String]', 'Use it to insert a movie poster to te database (use only with -c or -u params)')   { |o| param.image = o }
        opt.on('-o', '--output, path to html output [String]', 'Use it to define where to make an html file with the result of a search (used with -r parameter)')   { |o| param.image = o }
        opt.on_tail('-v', '--version', 'Shows version') { puts "moviesX v0.9"; exit }
        opt.on_tail('-h', '--help', 'This script is used to store information about movies in a mongo data base, you will be able to modify all this information with this script, see options for futher details') { puts "\n\n\n\n"; puts opt; puts "\n\n"; exit }
end.parse!


##Connection to database
# client = Mongo::Client.new('mongodb://127.0.0.1:27017/moviesx')
# collection = client[:peliculas]

#-.- modelo de pelicula -.-##############
# pelicula = { 
#  nombre: '',
#  directores: [ '', '', '' ],
#  actores: [ '', '', '' ] ,
#  generos: [ '', '' ],
#  poster: '',
#  año: '',
#  duracion: '',
#  sinopsis: ''
# }
###################################

# result = collection.insert_one(doc)
# result.n # returns 1, because one document was inserted

#Tools
def imageProcess(path)
	 formatosDeImagen = [ ".jpg", ".jpeg", ".png"]
	if path
		if File.file?(path) &&  formatosDeImagen.include?(File.extname(path))
			encoded_string = Base64.encode64(File.open(path, "rb").read)
			return encoded_string
		elsif 
			
		else
			abort ("Your path is not a file or your image hasnt a valid extention (must be: jpg or png).")
		end
	else
		return ""
	end
end

def htmlOutput(name, description, lenght, poster, directors, genre, year, imageType, staff)

	archivo = File.new("Pelicula_#{name}.html", "w+")
	
	archivo.puts '<!doctype html>'
	archivo.puts '<html lang="en">'
	archivo.puts '<head>'
	archivo.puts 	'<meta charset="utf-8">'
	archivo.puts 	'<title>MoviesX</title>'
	archivo.puts 	'<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">'
  	archivo.puts 	'<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>'
 	archivo.puts 	'<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>'
	archivo.puts '</head>'
	archivo.puts '<body>'
	archivo.puts 	'<p><b>--------------------------MoviesX---------------------------</b></p>'
	archivo.puts 	'<p>You have searched for #{name}:</p>'
	archivo.puts 	'<br />'
	archivo.puts 	'<div class="col-md-4">'
	archivo.puts		'<img src="data:image/#{imageType};base64, #{poster}" alt="Not set"/>'
	archivo.puts 	'</div>'
	archivo.puts 	'<div class="col-md-8">'
	archivo.puts		'<ul>'
	archivo.puts			'<li>Movie:  #{name}</li>'
	archivo.puts			'<li>Lenght: #{lenght}</li>'
	archivo.puts			'<li>Genre:  #{genre}</li>'
	archivo.puts			'<li>Year:   #{year}</li>'
	archivo.puts			'<br />'
	archivo.puts			'<li>Directors: #{directors}</li>'
	archivo.puts			'<li>Staff:     #{staff}</li>'
	archivo.puts			'<br />'
	archivo.puts		'</ul>'
	archivo.puts 	'</div>'
	archivo.puts 	'<p><b>------------------------------------------------------------</b></p>'
	archivo.puts 	'<br />'
	archivo.puts '</body>'
	archivo.puts '</html>'
	
end



#Programa principal
puts "Welcome to MoviesX"
encoded_image = imageProcess(param.image)


if param.create

	puts "You are going to register a new movie"
		

end


if param.read

	puts "you are getting the movies"

end

if param.update

	puts "you are going to update a movie"
	puts "#{param.update}"

end

if param.delete

	puts "you are going to delete a movie"
	puts "#{param.delete}"

end


Catpix::print_image param.image,
  :limit_x => 1.0,
  :limit_y => 0,
  :center_x => true,
  :center_y => true,
  :bg => "white",
  :bg_fill => true,
  :resolution => "auto"


puts encoded_image

