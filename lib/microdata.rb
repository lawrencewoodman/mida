require 'nokogiri'

class Microdata

	attr_reader :itemscopes

	def initialize(target)
		@doc = Nokogiri(target)
		@itemscopes = get_itemscopes(@doc, true)
	end

	def find(vocabulary=nil)
		itemscopes = vocabulary.nil? ? @itemscopes : filter_vocabularies(@itemscopes, vocabulary)

		itemscopes.empty? ? nil : itemscopes
	end

private
	def get_itemscopes(doc, first)
		itemscopes_doc = if first
			doc.search('//*[@itemscope and not(ancestor::*/@itemscope)]')
		else
			doc.search('./*[@itemscope and not(ancestor::*/@itemscope)]')
		end

		if itemscopes_doc.nil? then return nil end

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

		return itemscopes
	end

	def get_properties(itemscope)
		itemprops = itemscope.search('./*[@itemprop]')
		properties = {}

		itemprops.each do |itemprop|
			property = itemprop.attribute('itemprop').value

			if itemprop.attribute('itemscope').nil?
				properties[property] = case itemprop.name
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

		return (properties.keys == 0) ? nil : properties
	end

	def filter_vocabularies(itemscopes, vocabulary)
		itemscope_vocabularies = []

		itemscopes.each do |itemscope|
			itemscope_vocabularies << itemscope unless itemscope[:type].to_s != vocabulary

			itemscope[:properties].each do |property|
				if property.is_a?(Hash)
					itemscope_vocabularies << filter_vocabularies(property, vocabulary)
				end
			end
		end

		itemscope_vocabularies
	end

end
