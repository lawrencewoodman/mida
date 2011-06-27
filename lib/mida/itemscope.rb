require 'nokogiri'

module Mida

  # Class that parses itemscope elements
  class Itemscope

    # The Type of the itemscope
    attr_reader :type

    # The Global Identifier of the itemscope
    attr_reader :id

    # A Hash representing the properties as name/values paris
    # The values will be an array containing either +String+
    # or <tt>Mida::Item</tt> instances
    attr_reader :properties

    # Create a new Itemscope object
    #
    # [itemscope_node] The itemscope_node that you want to parse.
    # [page_url] The url of target used for form absolute url.
    def initialize(itemscope_node, page_url=nil)
      @itemscope_node, @page_url = itemscope_node, page_url
      @type, @id = extract_attribute('itemtype'), extract_attribute('itemid')
      @properties = {}
      add_itemref_properties
      parse_elements(extract_elements(@itemscope_node))
    end

    # Same as +new+ for convenience
    def self.parse(itemscope, page_url=nil)
      self.new itemscope, page_url
    end

    def ==(other)
      @type == other.type && @id == other.id && @properties == other.properties
    end

  private

    def extract_attribute(attribute)
      (value = @itemscope_node.attribute(attribute)) ? value.value : nil
    end

    def extract_elements(itemscope)
      itemscope.search('./*')
    end

    # Find an element with a matching id
    def find_with_id(id)
      @itemscope_node.search("//*[@id='#{id}']")
    end

    # Add any properties referred to by 'itemref'
    def add_itemref_properties
      itemref = extract_attribute('itemref')
      if itemref
        itemref.split.each {|id| parse_elements(find_with_id(id))}
      end
    end

    def parse_elements(elements)
      elements.each {|element| parse_element(element)}
    end

    def parse_element(element)
      itemscope = element.attribute('itemscope')
      itemprop = element.attribute('itemprop')
      internal_elements = extract_elements(element)
      add_itemprop(element) if itemscope || itemprop
      parse_elements(internal_elements) if internal_elements && !itemscope
    end

    # Add an 'itemprop' to the properties
    def add_itemprop(itemprop)
      properties = Itemprop.parse(itemprop, @page_url)
      properties.each { |name, value| (@properties[name] ||= []) << value }
    end

  end
end
