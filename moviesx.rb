
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
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end
  
  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
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
        opt.on('-r', '--read',   'This option is used to get the information of the movies.')      { |o| param.read = o }
        opt.on('-u', '--update Movie name [String]', 'Prompts the update function of a movie')   { |o| param.update = o }
        opt.on('-d', '--delete Movie name [String]', 'Prompts the delete function of a movie')   { |o| param.delete = o }
        opt.on('-f', '--filter query [String]',   'If set, the script will execute a filter by name query with it.')     { |o| param.filter = o }
        opt.on('-i', '--image Movie poster, path to image file [String]', 'Use it to insert a movie poster to te database (use only with -c or -u params)')   { |o| param.image = o }
        opt.on('-o', '--output, path to html output [String]', 'Use it to define where to make an html file with the result of a search (used with -r parameter)')   { |o| param.output = o }
        opt.on_tail('-v', '--version', 'Shows version') { puts "moviesX v0.9"; exit }
        opt.on_tail('-h', '--help', 'This script is used to store information about movies in a mongo data base, you will be able to modify all this information with this script, see options for futher details') { puts "\n\n\n\n"; puts opt; puts "\n\n"; exit }
end.parse!


##Connection to database
Mongo::Logger.logger       = ::Logger.new('mongo.log')
Mongo::Logger.logger.level = ::Logger::INFO

client = Mongo::Client.new('mongodb://127.0.0.1:27017/moviesx')
collection = client[:peliculas]

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
			return encoded_string = Base64.encode64(File.open(path, "rb").read)
		elsif path =~ /^((http[s]?|ftp):\/)?\/?([^:\/\s]+)((\/\w+)*\/)([\w\-\.]+[^#?\s]+)(.*)?(#[\w\-]+)?$/
			download = open(path)
			IO.copy_stream(download, 'image.png')
			return encoded_string = Base64.encode64(File.open('image.png', "rb").read)
		else
			abort ("Your path is not a file or your image hasnt a valid extention (must be: jpg or png) Or a valid URL.")
		end
	else
		return ""
	end
end

def decodeImage(imageIn64)
	File.open('decoded.png', 'wb') do|f|
		f.write(Base64.decode64(imageIn64))
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
	archivo.puts 	"<p>You have searched for #{name}:</p>"
	archivo.puts 	'<br />'
	archivo.puts 	'<div class="col-md-4">'
	archivo.puts		"<img src='data:image/#{imageType};base64, #{poster}' alt='Not set'/>"
	archivo.puts 	'</div>'
	archivo.puts 	'<div class="col-md-8">'
	archivo.puts		'<ul>'
	archivo.puts			"<li>Movie:  #{name}</li>"
	archivo.puts			"<li>Lenght: #{lenght}</li>"
	archivo.puts			"<li>Genre:  #{genre}</li>"
	archivo.puts			"<li>Year:   #{year}</li>"
	archivo.puts			"<br />"
	archivo.puts			"<li>Directors: #{directors}</li>"
	archivo.puts			"<li>Staff:     #{staff}</li>"
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
		

	puts "Movie name: "
	name = gets.chomp
	while !name.validate(validateString) do
		puts "Not a valid name, try again".red
		name = gets.chomp
	end

	puts "Directed by: (Enter directors separated by commas)"	
	directors = gets.chomp
	while !directors.validate(validateString) do
		puts "Not a valid String, try again".red
		directors = gets.chomp
	end

	puts "Actors: (Enter actors separated by commas)"	
	actors = gets.chomp
	while !actors.validate(validateString) do
		puts "Not a valid String, try again".red
		actors = gets.chomp
	end

	puts "Genres: (Enter genres separated by commas)"	
	genres = gets.chomp
	while !genres.validate(validateString) do
		puts "Not a valid String, try again".red
		genres = gets.chomp
	end

	puts "Year: "
	year = gets.chomp
	while !year.validate(validateNumber) do
		puts "Not a valid year, try again".red
		year = gets.chomp
	end

	puts "Lenght: (in minutes)"
	lenght = gets.chomp
	while !lenght.validate(validateNumber) do
		puts "Not a valid time, try again".red
		lenght = gets.chomp
	end
	
	puts "Movie resume: "
	resume = gets.chomp
	while !resume.validate(validateText) do
		puts "Not a valid paragrahp, try again".red
		resume = gets.chomp
	end

	
	pelicula = { 
		nombre: name,
		directores: directors.split(","),
		actores: actors.split(",") ,
		generos: genres.split(","),
		poster: encoded_image,
		año: year,
		duracion: lenght,
		sinopsis: resume
	}


	result = collection.insert_one(pelicula) 
	if result.n  == 1
		puts "Pelicula insertada"
	end

end


if param.read

	puts "you are getting the movies"
	puts "--------------------------"
	id     = ""
	nombre = ""
	año    = ""
	directores = ""
	actores    = ""
	generos    = ""
	poster     = ""
	duracion   = ""
	sinopsis    = ""

	pelicula = Hash.new
	listaPeliculas = []
		

	# Search query
	if param.filter		
		cursor = collection.find(nombre: '#{param.filter}')

		cursor.each do |doc|
			id =        doc["_id"]
			nombre =    doc["nombre"]

			pelicula = [:id => id, :nombre => nombre]
			listaPeliculas << pelicula
		end

		index = 1
		listaPeliculas.each do |pelicula|
			puts "#{index}.- #{pelicula[0][:nombre]}"
			index += 1
		end

	# Search everything	
	else
		cursor = collection.find

		cursor.each do |doc|
			id =        doc["_id"]
			nombre =    doc["nombre"]

			pelicula = [:id => id, :nombre => nombre]
			listaPeliculas << pelicula
		end

		index = 1
		listaPeliculas.each do |pelicula|
			puts "#{index}.- #{pelicula[0][:nombre]}"
			index += 1
		end
	end
	
	if !listaPeliculas.empty?
		puts "Enter a movie number to view details"
		choice = gets.chomp.to_i-1
		while !choice.to_s.validate(validateNumber) && !(choice < listaPeliculas.length) do
			puts "Enter a valid number"
			choice = gets.chomp.to_i-1
		end

		cursor = collection.find(:_id => BSON::ObjectId("#{listaPeliculas[choice][0][:id]}"))


		cursor.each do |doc|
			id =        doc["_id"]
			nombre =    doc["nombre"]
			año =       doc["año"]
			poster =    doc["poster"]
			sinopsis =  doc["sinopsis"]
			duracion =  doc["duracion"]
			directores= doc["directores"].to_bson_normalized_value
			actores =   doc["actores"].to_bson_normalized_value
			generos =   doc["generos"].to_bson_normalized_value


		end

		# output html?
		if param.output
		
			htmlOutput(nombre, sinopsis, duracion, poster, directores, generos, año, 'png', actores)
			puts "http://mechsolutions.sytes.net/Pelicula_#{nombre}.html/"

		#output terminal
		else

			puts "-----------Movie info:------------"
			puts "name: #{nombre}"
			puts "year: #{año}"
			puts "length: #{duracion}"
			puts "resume: #{sinopsis}"
			puts "directed by: #{directores.join(",")}"
			puts "staff: #{actores.join(",")}"
			puts "genres: #{generos.join(",")}"

			if poster != ""
				decodeImage(poster)
				Catpix::print_image 'decoded.png',
				  :limit_x => 1.0,
				  :limit_y => 0,
				  :center_x => true,
				  :center_y => true,
				  :bg => "white",
				  :bg_fill => true,
				  :resolution => "auto"
			else
				puts "There is no image for this movie."
			end

			puts "---------------------------------"

		end

	else
		puts "There are no movies"
	end


end

if param.update

	puts "you are going to update a movie"
	puts "#{param.update}"

end

if param.delete

	puts "you are going to delete a movie"
	puts "#{param.delete}"

end

client.close
