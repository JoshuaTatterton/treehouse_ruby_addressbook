require "./contact"
require "yaml"

class AddressBook
	
	attr_reader :contacts

	def initialize
		@contacts = []
		open
	end

	def open
		if File.exists?("contacts.yml")
			@contacts = YAML.load_file("contacts.yml")
		end
	end

	def save
		File.open("contacts.yml", "w") do |file|
			file.write(contacts.to_yaml)
		end
	end

	def run
		loop do
			print "\n"
			puts "Address Book"
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
				print "Contact name to delete (First name + Last name): "
				delete_contact_by_name(gets.chomp)
			when "e"
				print "Contact name to edit (First name + Last name): "
				edit_contact_by_name(gets.chomp)
			when "p"
				print_contact_list
			when "s"
				print "Search term: "
				search = gets.chomp
				find_by_name(search)
				find_by_address(search)
				find_by_phone_number(search)
			when "q"
				save
				break
			end
		end
	end

	def add_contact
		contact = Contact.new
		print "First name: "
		contact.first_name = gets.chomp
		print "Middle name: "
		contact.middle_name = gets.chomp
		print "Last name: "
		contact.last_name = gets.chomp

		loop do
			puts "Add phone number or address"
			puts "p: Add phone number"
			puts "a: Add address"
			puts "(any other key to go back)"
			responce = gets.chomp.downcase
			case responce
			when "p"
				phone = PhoneNumber.new
				print "Phone number kind: "
				phone.kind = gets.chomp
				print "Number: "
				phone.number = gets.chomp
				contact.phone_numbers.push(phone)
			when "a"
				address = Address.new
				print "Address kind: "
				address.kind = gets.chomp
				print "Address line 1: "
				address.street_1 = gets.chomp
				print "Address line 2: "
				address.street_2 = gets.chomp
				print "City: "
				address.city = gets.chomp
				print "State: "
				address.city = gets.chomp
				print "Postal code; "
				address.postal_code = gets.chomp
				contact.addresses.push(address)
			else
				print "\n"
				break
			end
		end
		contacts.push(contact)
	end

	def delete_contact_by_name(query)
		result = nil
		search = query
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

	def edit_contact_by_name(query)
		result = nil
		search = query
		contacts.each do |contact|
			if contact.first_last.downcase == search.downcase
				result = contact
			end
		end
		if result.nil?
			puts "#{search} did not match a contact"
		else
			loop do
				puts "Select information to change"
				puts "n: Name"
				# puts "a: Addresses"
				# puts "p: Phone Numbers"
				input = gets.chomp
				case input
				when "n"
					edit_contact_name(result)
				# when "a"
				# 	edit_contact_addresses(result)
				# when "p"
				# 	edit_contact_numbers(result)
				else
					break
				end
			end
		end
	end

	def edit_contact_name(contact)
		loop do
			puts "Select name to change"
			puts "f: First Name (Current - #{contact.first_name})"
			puts "m: Middle Name (Current - #{contact.middle_name})"
			puts "l: Last Name (Current - #{contact.last_name}"
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
	end

	def edit_contact_number(contact)
	end

	def print_results(search, results)
		puts search
		results.each do |contact|
			puts contact.to_s("full_name")
			contact.print_phone_numbers
			contact.print_addresses
			puts "\n"
		end
	end

	def find_by_name(name)
		results = []
		search = name.downcase
		contacts.each do |contact|
			if contact.full_name.downcase.include?(search)
				results.push(contact)
			end
		end
		print_results("Name search results (#{search})", results)
	end

	def find_by_phone_number(number)
		results = []
		search = number.gsub("-", "")
		contacts.each do |contact|
			contact.phone_numbers.each do |phone_number|
				if phone_number.number.gsub("-", "").include?(search)
					results.push(contact) unless results.include?(contact)
				end
			end
		end
		print_results("Phone search results (#{search})", results)
	end

	def find_by_address(query)
		results = []
		search = query.downcase
		contacts.each do |contact|
			contact.addresses.each do |address|
				if address.to_s("long").downcase.include?(query)
					results.push(contact) unless results.include?(contact)
				end
			end
		end
		print_results("Address search results (#{query})", results)
	end

	def print_contact_list
		puts "Contact List"
		contacts.each { |contact| puts contact.to_s("last_first") }
	end

end

address_book = AddressBook.new

address_book.run
