class Item

  attr_reader :type

  def initialize
    @type = get_type
  end

  # generates a random item type from all possible item types, found in public/img/items 
  def get_type
    #@type = type
    get_type_array.sample
  end

  # helper_method for get_type
  def get_type_array
    Dir["/Users/annaershova/Flatiron/oo-neopet-html-generator-web-0615/public/img/items/*"].collect do |file|
      file.split("/").last.gsub(".jpg","")
    end
  end

  # replaces the underscores in the type name with spaces and capitalizes the type name 
  def format_type
    @type.gsub("_"," ").split.map(&:capitalize)*' '
  end

end # end class

#=> we have a random item from an array, and we can format a name