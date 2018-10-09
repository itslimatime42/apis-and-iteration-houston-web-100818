require 'rest-client'
require 'json'
require 'pry'

# Make web request to an API, store JSON in hash variable
def web_request(url)
  JSON.parse(RestClient.get("#{url}"))
end

# Pull value from hash given key
def get_hash_value(hash, key)
  hash[key]
end

# Finds desired character given an array of character hashes
def find_character(character, array_of_characters)
  array_of_characters.each do |character_hash|
    if character_hash["name"].downcase == character.downcase
      return character_hash
    end
  end
  return {}
end 

# prints error message if character does not exist in API
def invalid_character
  puts "Character not found. Try another."
  return false
end

# iterate over an array of URL's and makes web requests for each
def url_mapper(url_array)
  url_array.map do |url|
    web_request(url)
  end
end

# Takes character as input, returns array of film hashes
def get_character_movies_from_api(character)

  # Make web request to Star Wars API, store resulting hash in variable
  response_hash = web_request('http://www.swapi.co/api/people/')

  # Finding the array of all characters given response_hash
  array_of_characters = get_hash_value(response_hash, "results")

  # Pull desired character hash from character array
  character_hash = find_character(character, array_of_characters)
  
  # Check that character exists
  if character_hash == {}
    return nil
  end

  # Store films for a given character in an array (of hashes)
  films_array = get_hash_value(character_hash, "films")

  # Iterate over films, making web requests for each, store film data in new array
  new_films_array = url_mapper(films_array)
  
end

def print_movies(new_films_array)
  new_films_array.each do |film_hash|
    puts film_hash["title"]
  end
end

def show_character_movies(character)
  films_array = get_character_movies_from_api(character)

  # Check if film array exists (it won't if character was invalid)
  if films_array == nil
    invalid_character
  else
  print_movies(films_array)
  end
end
