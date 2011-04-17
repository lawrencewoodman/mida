require 'nokogiri'
require 'uri'

module Mida

  # Module that parses itemprop elements
  module Property

    # Returns a Hash representing the property.
    # Hash is of the form {'property name' => 'value'}
    # [element] The itemprop element to be parsed
    # [page_url] The url of the page, including the filename, used to form absolute urls
    def self.parse(element, page_url=nil)
      extract_property_names(element).each_with_object({}) do |name, memo|
        memo[name] = extract_property(element, page_url)
      end
    end

    NON_TEXTCONTENT_ELEMENTS = {
      'a' => 'href',        'area' => 'href',
      'audio' => 'src',     'embed' => 'src',
      'iframe' => 'src',    'img' => 'src',
      'link' => 'href',     'meta' => 'content',
      'object' => 'data',   'source' => 'src',
      'time' => 'datetime', 'track' => 'src',
      'video' => 'src'
    }

    URL_ATTRIBUTES = ['data', 'href', 'src']

    # This returns an empty string if can't form a valid
    # absolute url as per the Microdata spec.
    def self.make_absolute_url(url, page_url)
      return url unless URI.parse(url).relative?
      begin
        URI.parse(page_url).merge(url).to_s
      rescue URI::Error
        ''
      end
    end

    def self.extract_property_names(itemprop)
      itemprop_attr = itemprop.attribute('itemprop')
      itemprop_attr ? itemprop_attr.value.split() : []
    end

    def self.extract_property_value(itemprop, page_url)
      element = itemprop.name
      if NON_TEXTCONTENT_ELEMENTS.has_key?(element)
        attribute = NON_TEXTCONTENT_ELEMENTS[element]
        value = itemprop.attribute(attribute).value
        (URL_ATTRIBUTES.include?(attribute)) ? make_absolute_url(value, page_url) : value
      else
        itemprop.inner_text
      end
    end

    def self.extract_property(itemprop, page_url)
      if itemprop.attribute('itemscope')
        Mida::Item.new(itemprop, page_url)
      else
        extract_property_value(itemprop, page_url)
      end
    end

  end

end
