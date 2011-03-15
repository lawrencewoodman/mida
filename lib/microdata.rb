require 'nokogiri'

class Microdata

	attr_reader :itemscopes

	def initialize(target)
		@doc = Nokogiri(target)
		@itemscopes = get_itemscopes(@doc)
	end

	def find(vocabulary=nil)
		itemscopes = vocabulary.nil? ? @itemscopes : filter_vocabularies(@itemscopes, vocabulary)
		itemscopes.empty? ? nil : itemscopes
	end

private
	def get_itemscopes(doc)
		itemscopes_doc = doc.search('//*[@itemscope and not(@itemprop)]')

		return nil if itemscopes_doc.nil?

		itemscopes = []
		itemscopes_doc.each do |itemscope_doc|
			itemscope = {}
			if itemscope_doc.attribute('itemtype').nil?
				itemscope[:type] = nil
			else
				itemscope[:type] = itemscope_doc.attribute('itemtype').value
			end
			itemscope[:properties] = get_properties(itemscope_doc)
			itemscopes << itemscope
		end

		itemscopes
	end

	def get_itemprops(itemscope)
		tags = itemscope.search('./*')
		itemprops = []

		tags.each do |tag|
			if tag.attribute('itemprop').nil?
				itemprops += get_itemprops(tag)
			else
				itemprops << tag
			end
		end

		(itemprops.nil?) ? nil : itemprops
	end

	def get_properties(itemscope)
		itemprops = get_itemprops(itemscope)
		return nil if itemprops.nil?
		properties = {}

		itemprops.each do |itemprop|
			property = itemprop.attribute('itemprop').value

			if itemprop.attribute('itemscope').nil?
				properties[property] =
					case itemprop.name
					when 'time' then itemprop.attribute('datetime').value
					else itemprop.inner_text
				end
			else
				properties[property] = {}
				if itemprop.attribute('itemtype').nil?
					properties[property][:type] = nil
				else
					properties[property][:type] = itemprop.attribute('itemtype').value
				end
				properties[property][:properties] = get_properties(itemprop)
			end

		end

		(properties.keys == 0) ? nil : properties
	end

	def filter_vocabularies(itemscopes, vocabulary)
		itemscope_vocabularies = []

		itemscopes.each do |itemscope|
			itemscope_vocabularies << itemscope unless itemscope[:type] != vocabulary

			itemscope[:properties].each do |property|
				if property[1].is_a?(Hash)
					itemscope_vocabularies += filter_vocabularies([property[1]], vocabulary)
				end
			end
		end

		itemscope_vocabularies
	end

end
