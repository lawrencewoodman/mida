require 'nokogiri'
require 'uri'

module MiDa

  # Class that holds each property name/value pair
  class Property
    # The Name of the property
    attr_reader :name

    # The Value of the property
    attr_reader :value

    # Create a new Property object
    #
    # [property] The name of the property
    # [element] The itemprop element that is parsed to get the values
    # [page_url] The url of target used for form absolute urls
    def initialize(property, element, page_url=nil)
      @name = property
      @page_url = page_url
      @value = get_property(element)
    end

  private
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
    def make_absolute_url(url)
      return url unless URI.parse(url).relative?
      begin
        URI.parse(@page_url).merge(url).to_s
      rescue URI::Error
        ''
      end
    end

    def get_property_value(itemprop)
      element = itemprop.name
      if NON_TEXTCONTENT_ELEMENTS.has_key?(element)
        attribute = NON_TEXTCONTENT_ELEMENTS[element]
        value = itemprop.attribute(attribute).value
        (URL_ATTRIBUTES.include?(attribute)) ? make_absolute_url(value) : value
      else
        itemprop.inner_text
      end
    end

    def get_property(itemprop)
      if itemprop.attribute('itemscope')
        Item.new(itemprop, @page_url)
      else
        get_property_value(itemprop)
      end
    end

  end

end
