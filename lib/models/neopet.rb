require 'pry'

class Neopet

  attr_accessor :items, :happiness
  attr_reader :name, :species, :strength, :defence, :movement
  NEOPETS_DIR = "/Users/annaershova/Flatiron/oo-neopet-html-generator-web-0615/public/img/neopets/*"

  def initialize(name)
    @name = name
    @species = get_species
    @strength = get_points
    @defence = get_points
    @movement = get_points
    @happiness = get_points
    @items = Array.new
    #get_points to assign strength, defence, movement, and happiness
  end


  def get_species
    get_species_array.sample
    # array_size = species_array.flatten.uniq.size -- or use that to do a range
    # selects a random species from the file names in public/img/neopets 
    # collect file names, removes jpg, assign to an array, choose random from an array
  end

  # helper method for get_species
  def get_species_array
    Dir[NEOPETS_DIR].collect {|file| file.split("/").last.gsub(".jpg","") }
  end

  def get_points
    rand(1..10)
  end

  def mood
    case @happiness
    when 1,2
      "depressed"
    when 3,4
      "sad"
    when 5,6
      "meh"
    when 7,8
      "happy"
    else
      "ecstatic"
    end # end case
  end # end method

    #has a reader method
    #is intialized as an empty array (FAILED - 3)
    #has a writer method
    #allows for the addition of items (FAILED - 4)
    #allows for the substraction of items (FAILED - 5)

  # other methods here
end