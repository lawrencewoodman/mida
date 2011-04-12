require 'nokogiri'

module Mida

  # Class that holds each item/itemscope
  class Item
    # The Type of the item
    attr_reader :type

    # A Hash representing the properties as name/values paris
    # The values will be an array containing either +String+
    # or <tt>Mida::Item</tt> instances
    attr_reader :properties

    # Create a new Item object
    #
    # [itemscope] The itemscope that you want to parse
    # [page_url] The url of target used for form absolute urls
    def initialize(itemscope, page_url=nil)
      @itemscope = itemscope
      @page_url, @type = page_url, extract_itemtype()
      @properties = {}
      add_itemref_properties
      traverse_elements(extract_elements(itemscope))
    end

    # Return a Hash representation
    # of the form {type: 'The item type', properties: {'a name' => 'avalue' }}
    def to_h
      {type: @type, properties: properties_to_h(@properties)}
    end

    def to_s
      to_h.to_s
    end

    def ==(other)
      @type == other.type and @properties == other.properties
    end

  private

    def extract_itemtype
      if (type = @itemscope.attribute('itemtype')) then type.value else nil end
    end

    def extract_itemref
      (itemref = @itemscope.attribute('itemref')) ? itemref.value : nil
    end

    def extract_elements(itemscope)
      itemscope.search('./*')
    end

    # Find an element with a matching id
    def find_with_id(id)
      @itemscope.search("//*[@id='#{id}']")
    end

    # The value as it should appear in to_h()
    def value_to_h(value)
      case
      when value.is_a?(Array) then value.collect {|element| value_to_h(element)}
      when value.is_a?(Item) then value.to_h
      else value
      end
    end

    def properties_to_h(properties)
      hash = {}
      properties.each { |name, value| hash[name] = value_to_h(value) }
      hash
    end

    # Add any properties referred to by 'itemref'
    def add_itemref_properties
      itemref = extract_itemref()
      if itemref
        itemref.split.each {|id| traverse_elements(find_with_id(id))}
      end
    end

    def traverse_elements(elements)
      elements.each do |element|
        internal_elements = extract_elements(element)
        if internal_elements.empty? || element.attribute('itemscope')
          add_itemprop(element)
        else
          traverse_elements(internal_elements)
        end
      end
    end

    def add_itemprop(itemprop)
      properties = Property.parse(itemprop, @page_url)
      properties.each { |name, value| (@properties[name] ||= []) << value }
    end

  end

end
