require 'nokogiri'

module MiDa

  # Class that holds each item/itemscope
  class Item
    # The Type of the item
    attr_reader :type

    # A Hash containing the properties of the form {'property_name' => 'value', etc}
    # The values in the hash will be String or Item objects
    attr_reader :properties

    # Create a new Item object
    #
    # [itemscope] The itemscope that you want to parse
    # [page_url] The url of target used for form absolute urls
    def initialize(itemscope, page_url=nil)
      @type = MiDa.get_itemtype(itemscope)
      @properties = {}
      @page_url = page_url
      add_properties(itemscope)
    end

  private
    def add_properties(itemscope)
      elements = get_elements(itemscope)
      properties = get_itemprops(elements)
      return nil unless properties

      properties.each do |property|
        add_property(property.name, property.value)
      end
    end

    def get_elements(itemscope)
      itemscope.search('./*')
    end

    def get_property_names(itemprop)
      itemprop_attr = itemprop.attribute('itemprop')
      itemprop_attr ? itemprop_attr.value.split() : []
    end

    def get_itemprops(elements)
      properties = []
      elements.each do |element|
        internal_elements = get_elements(element)
        if internal_elements.empty? || element.attribute('itemscope')
          properties += get_itemprop(element)
        else
          properties += get_itemprops(internal_elements)
        end
      end
      properties
    end

    def get_itemprop(itemprop)
      get_property_names(itemprop).collect do |property|
        MiDa::Property.new(property, itemprop, @page_url)
      end
    end

    def add_property(property, value)
      if @properties.has_key?(property)
        if @properties[property].is_a?(Array)
          @properties[property] << value
        else
          @properties[property] = [@properties[property], value]
        end
      else
        @properties[property] = value
      end
    end
  end

end
