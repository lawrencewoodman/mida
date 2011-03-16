require 'nokogiri'
require 'uri'

class Microdata

	attr_reader :itemscopes

	def initialize(target, page_url=nil)
		@doc = Nokogiri(target)
		@page_url = page_url
		@itemscopes = get_itemscopes(@doc)
	end

	def find(vocabulary=nil)
		itemscopes = vocabulary.nil? ? @itemscopes : filter_vocabularies(@itemscopes, vocabulary)
		itemscopes.empty? ? nil : itemscopes
	end

private

	NON_TEXTCONTENT_ELEMENTS = {
		'a' => 'href',     'area' => 'href',
		'audio' => 'src',  'embed' => 'src',
		'iframe' => 'src', 'img' => 'src',
		'link' => 'href',  'meta' => 'content',
		'object' => 'data', 'source' => 'src',
		'time' => 'datetime', 'track' => 'src',
		'video' => 'src'
	}

	URL_ATTRIBUTES = ['data', 'href', 'src']

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

	# Note that this returns an empty string if can't form a valid url
	# as per the Microdata spec
	def make_absolute_url(url)
		return url unless URI.parse(url).relative?
		return '' if @page_url.nil? or URI.parse(@page_url).relative?
		URI.parse(@page_url).merge(url).to_s
	end

	def get_property_value(itemprop)
		element = itemprop.name
		value = if NON_TEXTCONTENT_ELEMENTS.has_key?(element)
			attribute = NON_TEXTCONTENT_ELEMENTS[element]
			value = itemprop.attribute(attribute).value
			(URL_ATTRIBUTES.include?(attribute)) ? make_absolute_url(value) : value
		else
			itemprop.inner_text
		end
	end

	def get_properties(itemscope)
		itemprops = get_itemprops(itemscope)
		return nil if itemprops.nil?
		properties = {}

		itemprops.each do |itemprop|
			property = itemprop.attribute('itemprop').value

			if itemprop.attribute('itemscope').nil?
				properties[property] = get_property_value(itemprop)
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
