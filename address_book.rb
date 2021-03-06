require "./contact"
require "yaml"

class AddressBook
	
	attr_reader :contacts

	def initialize
		@contacts = []
		open
	end

	def open
		@contacts = YAML.load_file("contacts.yml") if File.exists?("contacts.yml")
	end

	def save
		File.open("contacts.yml", "w") do |file|
			file.write(contacts.to_yaml)
		end
	end

	def run
		loop do
			puts "\nAddress Book"
			puts "a: Add Contact"
			puts "d: Delete Contact"
			puts "e: Edit Contact"
			puts "p: Print Address Book"
			puts "s: Search"
			puts "q: Quit"
			print "Enter your choice: "
			input = gets.chomp.downcase

			case input
			when "a"
				add_contact
			when "d"
				print "\nContact name to delete (First + Last name): "
				delete_contact_by_name(gets.chomp)
			when "e"
				print "\nContact name to edit (First + Last name): "
				edit_contact_by_name(gets.chomp)
			when "p"
				print_contact_list
			when "s"
				print "\nSearch term: "
				search_contacts(gets.chomp)
			when "q"
				save
				break
			end
		end
	end

	def add_contact
		contact = Contact.new
		loop do
			print "\nFirst name: "
			contact.first_name = gets.chomp
			print "Middle name: "
			contact.middle_name = gets.chomp
			print "Last name: "
			contact.last_name = gets.chomp
			break if !(all_first_last_names.include?(contact.first_last.downcase))
			puts "#{contact.first_last} already exists in address book please reenter name"
		end
		loop do
			puts "Add phone number or address"
			puts "p: Add phone number"
			puts "a: Add address"
			puts "(any other key to go back)"
			print "Enter your choice: "
			input = gets.chomp.downcase
			case input
			when "p"
				add_phone_number_to_contact(contact)
			when "a"
				add_address_to_contact(contact)
			else
				break
			end
		end
		contacts.push(contact)
	end

	def search_contacts(search)
		find_by_name(search)
		find_by_address(search)
		find_by_phone_number(search)
	end

	def add_phone_number_to_contact(contact)
		phone = PhoneNumber.new
		print "\nPhone number kind: "
		phone.kind = gets.chomp
		loop do
			if contact.phone_number_kinds.include?(phone.kind.downcase)
				puts "Phone number kind already in use"
				print "Please enter a different phone number kind: "
				phone.kind = gets.chomp
			else
				break
			end
		end
		print "Number: "
		phone.number = gets.chomp
		contact.phone_numbers.push(phone)
	end

	def add_address_to_contact(contact)
		address = Address.new
		print "\nAddress kind: "
		address.kind = gets.chomp
		loop do
			if contact.address_kinds.include?(address.kind.downcase)
				puts "Address kind already in use"
				print "Please enter a different address kind: "
				address.kind = gets.chomp
			else
				break
			end
		end
		print "Address line 1: "
		address.street_1 = gets.chomp
		print "Address line 2: "
		address.street_2 = gets.chomp
		print "Town/City: "
		address.city = gets.chomp
		print "County: "
		address.county = gets.chomp
		print "Post Code: "
		address.post_code = gets.chomp
		contact.addresses.push(address)
	end

	def delete_contact_by_name(search)
		result = nil
		contacts.each do |contact|
			if contact.first_last.downcase == search.downcase
				result = contact
			end
		end
		if result.nil?
			puts "#{search} did not match a contact"
		else
			contacts.delete(result)
			puts "#{search} deleted from address book"
		end
	end

	def edit_contact_by_name(search)
		result = nil
		contacts.each do |contact|
			if contact.first_last.downcase == search.downcase
				result = contact
			end
		end
		if result.nil?
			puts "\n#{search} did not match a contact"
		else
			loop do
				puts "\nSelect information to change"
				puts "n: Name"
				puts "a: Addresses"
				puts "p: Phone Numbers"
				puts "(any other key to go back)"
				print "Enter your choice: "
				input = gets.chomp
				case input
				when "n"
					edit_contact_name(result)
				when "a"
					edit_contact_addresses(result)
				when "p"
					edit_contact_numbers(result)
				else
					break
				end
			end
		end
	end

	def edit_contact_name(contact)
		loop do
			puts "\nSelect name to change"
			puts "f: First Name (Current - #{contact.first_name})"
			puts "m: Middle Name (Current - #{contact.middle_name})"
			puts "l: Last Name (Current - #{contact.last_name}"
			puts "(any other key to go back)"
			print "Enter your choice: "
			input = gets.chomp
			case input
			when "f"
				print "Enter new first name: "
				contact.first_name = gets.chomp
			when "m"
				print "Enter new middle name: "
				contact.middle_name = gets.chomp
			when "l"
				print "Enter new last name: "
				contact.last_name = gets.chomp
			else
				break
			end
		end
	end

	def edit_contact_addresses(contact)
		loop do
			puts "\nSelect option"
			puts "a: Add new address"
			puts "e: Edit existing address"
			puts "d: Delete existing address"
			puts "p: Display all addresses"
			puts "(any other key to go back)"
			print "Enter your choice: "
			input = gets.chomp
			case input
			when "a"
				add_address_to_contact(contact)
			when "d"
				delete_address_from_contact(contact)
			when "e"
				edit_address_in_contact(contact)
			when "p"
				print_contacts_addresses(contact)
			else
				break
			end
		end
	end

	def delete_address_from_contact(contact)
		print "\nEnter the kind of address you wish to delete: "
		input = gets.chomp
		found = false
		contact.addresses.each do |address|
			if address.kind.downcase == input.downcase
				contact.addresses.delete(address) 
				puts "#{address.kind} Address Deleted"
				found = true
			end
		end
		puts "'#{input}' Address kind not found" if !found
	end

	def edit_address_in_contact(contact)
		print "\nEnter the kind of address you wish to edit: "
		input = gets.chomp
		found = false
		contact.addresses.each do |address|
			if address.kind.downcase == input.downcase
				edit_address(address)
				found = true
			end
		end
		puts "'#{input}' Address kind not found" if !found
	end

	def edit_address(address)
		loop do
			puts "\nSelect the address information to change"
			puts "k: Address Kind (Current - #{address.kind})"
			puts "a1: Address line 1 (Current - #{address.street_1})"
			puts "a2: Address line 2 (Current - #{address.street_2})"
			puts "t: Town/City (Current - #{address.city})"
			puts "c: County (Current - #{address.county})"
			puts "p: Post Code (Current - #{address.post_code})"
			puts "(any other key to go back)"	
			print "Enter your choice: "
			input = gets.chomp
			case input
			when "k"
				print "\nEnter new address kind: "
				address.kind = gets.chomp
			when "a1"
				print "Enter new address line 1: "
				address.street_1 = gets.chomp
			when "a2"
				print "Enter new address line 2: "
				address.street_2 = gets.chomp
			when "t"
				print "Enter new address town/city: "
				address.city = gets.chomp
			when "c"
				print "Enter new address county: "
				address.county = gets.chomp
			when "p"
				print "Enter new address post code: "
				address.post_code = gets.chomp
			else
				break
			end
		end
	end

	def print_contacts_addresses(contact)
		puts "\nAddresses"
		contact.addresses.each do |address|
			puts address.print_address 
		end
	end

	def edit_contact_numbers(contact)
		loop do
			puts "\nSelect option"
			puts "a: Add new phone number"
			puts "e: Edit existing phone number"
			puts "d: Delete existing phone number"
			puts "p: Print all phone numbers"
			puts "(any other key to go back)"
			print "Enter your choice: "
			input = gets.chomp
			case input
			when "a"
				add_phone_number_to_contact(contact)
			when "d"
				delete_phone_number_from_contact(contact)
			when "e"
				edit_phone_number_in_contact(contact)
			when "p"
				print_contacts_phone_numbers(contact)
			else
				break
			end
		end
	end

	def delete_phone_number_from_contact(contact)
		print "\nEnter the kind of phone number you wish to delete: "
		input = gets.chomp
		found = false
		contact.phone_numbers.each do |phone_number|
			if phone_number.kind.downcase == input.downcase
				contact.phone_numbers.delete(phone_number) 
				puts "#{phone_number.kind} Phone Number Deleted"
				found = true
			end
		end
		puts "'#{input}' Phone number kind not found" if !found
	end

	def edit_phone_number_in_contact(contact)
		print "\nEnter the kind of phone number you wish to edit: "
		input = gets.chomp
		found = false
		contact.phone_numbers.each do |phone_number|
			if phone_number.kind.downcase == input.downcase
				edit_phone_number(phone_number)
				found = true
			end
		end
		puts "'#{input}' Phone number kind not found" if !found
	end

	def edit_phone_number(phone_number)
		loop do
			puts "\nSelect the phone number information to change"
			puts "k: Phone Number Kind (Current - #{phone_number.kind})"
			puts "n: Phone Number (Current - #{phone_number.number}"
			puts "(any other key to go back)"
			print "Enter your choice: "
			input = gets.chomp
			case input
			when "k"
				print "Enter new phone number kind: "
				phone_number.kind = gets.chomp
			when "n"
				print "Enter new phone number: "
				phone_number.number = gets.chomp
			else 
				break
			end
		end
	end

	def print_contacts_phone_numbers(contact)
		puts "\nPhone Numbers"
		contact.phone_numbers.each do |phone_number|
			puts phone_number.print_number 
		end
	end

	def print_results(search, results)
		puts "\n" + search
		results.each do |contact|
			puts contact.print_name
			contact.print_phone_numbers
			contact.print_addresses
		end
	end

	def find_by_name(search)
		results = contacts.inject([]) do |result_memo, contact|
			if contact.full_name.downcase.include?(search.downcase)
				result_memo << contact
			end
			result_memo
		end
		print_results("Name search results (#{search})", results)
	end

	def find_by_phone_number(number)
		search = number.gsub(" ", "")
		results = contacts.inject([]) do |result_memo, contact|
			contact.phone_numbers.each do |phone_number|
				if phone_number.number.gsub(" ", "").include?(search)
					result_memo << contact unless result_memo.include?(contact)
				end
			end
			result_memo
		end
		print_results("Phone search results (#{search})", results)
	end

	def find_by_address(search)
		results = contacts.inject([]) do |result_memo, contact|
			contact.addresses.each do |address|
				if address.print_address("long").downcase.include?(search.downcase)
					result_memo << contact unless result_memo.include?(contact)
				end
			end
			result_memo
		end
		print_results("Address search results (#{search})", results)
	end

	def print_contact_list
		puts "\nContact List"
		contacts.each { |contact| puts contact.print_name("last_first") }
	end

	def all_first_last_names
    contacts.inject([]) do |result_memo, contact|
      result_memo << contact.first_last.downcase
    end
  end

end

address_book = AddressBook.new

address_book.run
