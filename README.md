# MoviesX
School project

This is a little project with ruby and mongodb. It is used to insert movies as documents to a mongo database with the following structure:

```ruby
 movie = {
  name: '',
  directors: [ '', '', '' ],
  staff: [ '', '', '' ] ,
  genres: [ '', '' ],
  poster: '',
  year: '',
  length: '',
  resume: ''
 }
```

And then you can get the information of the movie in console output or in a html file wich will normally go to your web server for easy access.

You can also use an image (jpg or png) specifying the path of the image file or you can also use an URL from the web, this image will be decoded into base64 and stored then when the user wants to se it it will be encoded and show as an image.

## How to

### Insert a movie

`moviesx.rb -c [-i pathToImageFile or URL]`

### Get the movies info

`moviesx.rb -r [-n | -y | -g] [-o]`

## Params in detail:

```shell
-c = create
-r = read
  -n = filter name
  -g = filter genre
  -y = filter year
-i = use image
-o = output result in HTML
-v = show version
-h = show help
```
