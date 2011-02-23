require 'hpricot'

class Microdata

	def self.find(*args)
		target = args[0]
		vocabulary = args[1] unless args[1].nil?

		doc = Hpricot(target)
		itemscopes = doc.search("*[@itemscope and @itemtype]")

		# TODO: Work out why the following code can't be replaced using:
		#	doc.search("*[@itemscope and ends-with(@itemtype, '#{vocabulary}')]")
		matching_itemscopes = Hpricot::Elements.new
		if !vocabulary.nil?
			# Remove any non-matching vocabularies
			itemscopes.each do |itemscope|
				if itemscope.attributes["itemtype"].end_with?(vocabulary)
					matching_itemscopes.push(itemscope)
				end
			end
			itemscopes = matching_itemscopes
		end

		o = Array.new

		itemscopes.each do |itemscope|
			md = new
			properties = md.get_properties(itemscope)
			type = itemscope.attributes["itemtype"].gsub(/.*?\//,'')

			if properties.size != 0
				md.instance_variable_set(:@properties, properties)
				md.instance_variable_set(:@type, type)
				o.push(md)
			end
		end

		case o.size
			when 1 then o.first
			when 0 then nil
			else o
		end

	end

	def type
		@type
	end

	def properties
		if @properties.nil? then return nil end
		@properties.keys
	end

	def get_properties(itemscope)
		itemprops = itemscope.search("*[@itemprop]")
		properties = Hash.new

		itemprops.each do |itemprop|
			property = itemprop.attributes["itemprop"]

			properties[property] = case itemprop.pathname
				when "time" then itemprop.attributes["datetime"]
				else itemprop.inner_text
			end

			# Define the getters for each property
			self.class.class_eval {
				define_method( property ) do
					@properties[property]
				end
			}
		end

		if properties.keys == 0
			return nil
		else
			return properties
		end
	end

end
