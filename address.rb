class Address

	attr_accessor :kind, :street_1, :street_2, :city, :state, :postal_code

	def print_address(format = "short")
		address = "#{kind}: "
		case format
		when "long"
			address += street_1 + "\n"
			address += street_2 + "\n" if !street_2.nil?
			address += "#{city}, #{state} #{postal_code}"
		when "short"
			address += street_1
			address += street_2 if !street_2.nil?
			address += ", #{city}, #{state}, #{postal_code}"
		end
	end

end
