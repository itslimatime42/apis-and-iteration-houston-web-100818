require 'rest-client'
require 'json'
require 'pry'

  # Find character_hash that matches character given input array_of_characters

def get_character_movies_from_api(character)
  #make the web request
  response_string = RestClient.get('http://www.swapi.co/api/people/')
  response_hash = JSON.parse(response_string)
  
  # Finding the array of all characters given response_hash
  array_of_characters = response_hash["results"]

  character_hash = find_character(character, array_of_characters)
  films_array = character_hash["films"]

  #binding.pry

  new_films_array = films_array.map do |movie_url|
    response_string = RestClient.get("#{movie_url}")
    response_hash = JSON.parse(response_string)
  end 

  #binding.pry 
end

def find_character(character, array_of_characters)
  array_of_characters.each do |character_hash|
    if character_hash["name"].downcase == character.downcase
      return character_hash
    end
    # loop back to the welcome message
  end
puts "Character not found."
end 

#get_character_movies_from_api("C-3PO")

def print_movies(new_films_array)
  new_films_array.each do |film_hash|
    puts film_hash["title"]
  end
end

def show_character_movies(character)
  films_array = get_character_movies_from_api(character)
  print_movies(films_array)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
