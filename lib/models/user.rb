require 'pry'

class User

  attr_reader :name
  attr_accessor :neopoints, :items, :neopets

  PET_NAMES = ["Angel", "Baby", "Bailey", "Bandit", "Bella", "Buddy", "Charlie", "Chloe", "Coco", "Daisy", "Lily", "Lucy", "Maggie", "Max", "Molly", "Oliver", "Rocky", "Shadow", "Sophie", "Sunny", "Tiger"]
  ITEM_PRICE = 150
  NEOPET_BID = 250
  NEOPET_ASK = 200

  def initialize(name)
    @name = name
    @neopoints = 2500
    @items = Array.new
    @neopets = Array.new
  end

  def select_pet_name # this is the most annoying selection method ever
    current_names = self.neopets.map {|pet|pet.name}
    possible_names = PET_NAMES.select {|name| !(current_names.include? name)}.sample
  end   

  def make_file_name_for_index_page
    self.name.gsub(" ","-").downcase
  end

  # finding methods
  def find_item_by_type(type)
    self.items.find {|item| item.type == type}
  end

  def find_neopet_by_name(name)
    self.neopets.find {|pet| pet.name == name}
  end

  # buy_item methods
  def buy_item
    liquid_for_item? ? execute_item_purchase : purchase_denied
  end 

  def liquid_for_item?
    @neopoints >= ITEM_PRICE
  end

  def execute_item_purchase
      purchased_item = Item.new
      @items << purchased_item
      decrement_for_item
      purchase_message
  end

  def decrement_for_item
    @neopoints -= ITEM_PRICE
  end

  def purchase_message
    "You have purchased a #{self.items[-1].type}."
  end

  def purchase_denied
    "Sorry, you do not have enough Neopoints."
  end

  # buy_neopet methods
  def buy_neopet
    liquid_for_neopet? ? execute_neopet_purchase : purchase_denied
  end 

  def liquid_for_neopet?
    @neopoints >= NEOPET_BID
  end

  def execute_neopet_purchase
      purchase_pet = Neopet.new(select_pet_name)
      @neopets << purchase_pet
      decrement_for_neopet
      neopet_purchase_message
  end

  def neopet_purchase_message
    "You have purchased a #{self.neopets[-1].species} named #{self.neopets[-1].name}."
  end

  def decrement_for_neopet
    @neopoints -= NEOPET_BID
  end

  # sell neopet methods
  def sell_neopet_by_name(name)
    find_neopet_by_name(name) ? execute_neopet_sale(name) : failed_neopet_sale_message
  end

  def execute_neopet_sale(name)
    increment_for_neopet
    remove_sold_pet(name)
    "You have sold #{name}. You now have #{@neopoints} neopoints."
  end

  def remove_sold_pet(name)
    self.neopets = self.neopets.select {|pet| name != pet.name}
  end

  def increment_for_neopet
    @neopoints += NEOPET_ASK
  end

  def failed_neopet_sale_message
    "Sorry, there are no pets named Lady."
  end

  # feeding neopet methods
  def feed_neopet_by_name(name)
    pet = find_neopet_by_name(name)
    happiness = pet.happiness
    case happiness
    when 10
      failed_feeding_message(name)
    when 9
      pet.happiness +=1
      successful_feeding_message(name)
    else
      pet.happiness +=2
      successful_feeding_message(name)
    end
  end

  def successful_feeding_message(name)
    pet = find_neopet_by_name(name)
    "After feeding, #{name} is #{pet.mood}."
  end

  def failed_feeding_message(name)
    pet = find_neopet_by_name(name)
    "Sorry, feeding was unsuccessful as #{name} is already #{pet.mood}."
  end

  # present methods 
  def give_present(type, name)
    present = find_item_by_type(type)
    pet = find_neopet_by_name(name)
    present&&pet ? execute_present(type,name) : failed_present_message
  end

  def execute_present(type,name)
    present = find_item_by_type(type)
    pet = find_neopet_by_name(name)
    pet.items << present
    self.items = self.items.select{|item|item != present}
    alter_mood(type,name)
  end

  def alter_mood(type,name)
    present = find_item_by_type(type)
    pet = find_neopet_by_name(name)
    if ecstatic?(name)
      pet.happiness = 10
    elsif pet.happiness >= 5
      pet.happiness = 10
      successful_present_message(type,name)
    else
      pet.happiness += 5
      successful_present_message(type,name)
    end
  end
  
  def ecstatic?(name)
    pet = find_neopet_by_name(name)
    pet.mood == "ecstatic" ? true : false
  end

  def successful_present_message(type,name)
    pet = find_neopet_by_name(name)
    "You have given a #{type} to #{name}, who is now #{pet.mood}."
  end

  def failed_present_message
    "Sorry, an error occurred. Please double check the item type and neopet name."
  end

  #html methods
  def make_index_page
    FileUtils.mkdir_p("views/users")
    
    template = ERB.new(File.read("/Users/annaershova/Flatiron/oo-neopet-html-generator-web-0615/lib/views/users/user.html.erb"))
    File.write("/Users/annaershova/Flatiron/oo-neopet-html-generator-web-0615/lib/views/users/#{make_file_name_for_index_page}.html", template.result(binding))
  end
 
end # end class