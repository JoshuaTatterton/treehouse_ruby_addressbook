require "./phone_number"
require "./address"

class Contact

  attr_writer :first_name, :middle_name, :last_name
  attr_reader :phone_numbers, :addresses

  def initialize
    @phone_numbers = []
    @addresses = []
  end

  def add_phone_number(kind, number)
    phone_number = PhoneNumber.new
    phone_number.kind = kind
    phone_number.number = number
    phone_numbers.push(phone_number)
  end

  def add_address(kind, street_1, street_2, city, county, post_code)
    address = Address.new
    address.kind = kind
    address.street_1 = street_1
    address.street_2 = street_2
    address.city = city
    address.county = county 
    address.post_code = post_code
    addresses.push(address)
  end

  def first_name
    @first_name
  end
  
  def middle_name
    @middle_name
  end
  
  def last_name
    @last_name
  end
  
  def full_name
    full_name = first_name
    if !@middle_name.nil?
      full_name += " "
      full_name += middle_name
    end
    full_name += " "
    full_name += last_name
    full_name
  end
  
  def last_first
    last_first = last_name
    last_first += ", "
    last_first += first_name
    if !(@middle_name == "")
      last_first += " "
      last_first += middle_name.slice(0,1)
      last_first += "."
    end
    last_first
  end
  
  def first_last
    first_last = first_name
    first_last += " "
    first_last += last_name
  end
  
  def print_name(format = "full_name")
    case format
      when "full_name"
        full_name
      when "last_first"
        last_first
      when "first"
        "first_name"
      when "last"
        last_name
      else "first_last"
        first_last
    end
  end

  def print_phone_numbers
    puts "Phone Numbers"
    phone_numbers.each { |number| puts number.print_number }
  end
  
  def print_addresses
    puts "Addresses"
    addresses.each { |address| puts address.print_address }
  end

  def address_kinds
    addresses.inject([]) do |result_memo, address|
      result_memo << address.kind.downcase
    end
  end

  def phone_number_kinds
    phone_numbers.inject([]) do |result_memo, phone_number|
      result_memo << phone_number.kind.downcase
    end
  end

end
