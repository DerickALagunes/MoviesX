
require 'mongo'
require 'optparse'
require 'ostruct'

#Parse parameters
param = OpenStruct.new
OptionParser.new do |opt|
        opt.banner = "Usage:ruby moviesx.rb [options]\n\n"
        opt.on('-c', '--create', 'This option is used to prompt the creation of a new register') { |o| param.create = o }
        opt.on('-r', '--read',   'This option is used to get the information of the movies')     { |o| param.read = o }
        opt.on('-u', '--update Movie name [String]', 'Prompts the update function of a movie')   { |o| param.update = o }
        opt.on('-d', '--delete Movie name [String]', 'Prompts the delete function of a movie')   { |o| param.delete = o }
        opt.on_tail('-v', '--version', 'Shows version') { puts "moviesX v0.9"; exit }
        opt.on_tail('-h', '--help', 'This script is used to store information about movies in a mongo data base, you will be able to modify all this information with this script, see options for futher details') { puts "\n\n\n\n"; puts opt; puts "\n\n"; exit }
end.parse!

#Programa principal
puts "Welcome to MoviesX"

if param.create

	puts "you are going to register a new movie"

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


