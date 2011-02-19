require 'hpricot'

class Microdata

	def initialize
		# Should raise an error if this is not overloaded?
	end

	def find(target)
		doc = Hpricot(target)
		doc.search("*[@itemscope='#{@vocabulary}']")

		@properties.keys.each do |field|
			element = doc.search("*[@itemprop='#{field}']")

			if (element.length > 0)
				@properties[field][:value] = case @properties[field][:type]
					when :datetime    then element.first['datetime']
					when :inner_text  then element.inner_text
					when :inner_float then Float(element.inner_text)
				end

				# Define the getters for the fields
				self.class.class_eval {
					define_method( field ) do 
						@properties[field][:value]
					end
				}

			else
				@properties.delete(field)
			end

		end

		return self
	end

	def properties
		@properties.keys
	end

end
