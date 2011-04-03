require 'nokogiri'

module MiDa

  # Class that holds each item/itemscope
  class Item
    # The Type of the item
    attr_reader :type

    # A Hash representing the properties
    # {'name' => 'value'}
    attr_reader :properties

    # Create a new Item object
    #
    # [itemscope] The itemscope that you want to parse
    # [page_url] The url of target used for form absolute urls
    def initialize(itemscope, page_url=nil)
      @page_url = page_url
      @type = MiDa.get_itemtype(itemscope)
      @properties = {}
      add_properties(get_elements(itemscope))
    end

    # Return a Hash representation
    # of the form {type: 'The item type, properties: {'a name' => 'avalue' }}
    def to_h
      hash = {type: @type, properties: {}}
      @properties.each do |name, value|
        hash[:properties][name] = if value.is_a?(Array)
          value.collect do |element|
            to_h_value(element)
          end
        else
          to_h_value(value)
        end
      end
      hash
    end

    def to_s
      {type: @type, properties: @properties}.to_s
    end

  private

    # The value as it should appear in to_h()
    def to_h_value(value)
      value.is_a?(Item) ? value.to_h : value
    end

    def get_elements(itemscope)
      itemscope.search('./*')
    end

    def add_properties(elements)
      elements.each do |element|
        internal_elements = get_elements(element)
        if internal_elements.empty? || element.attribute('itemscope')
          add_itemprop(element)
        else
          add_properties(internal_elements)
        end
      end
    end

    def add_itemprop(itemprop)
      properties = Property.parse(itemprop, @page_url)
      properties.each do |name, value|
        if @properties.has_key?(name)
          if @properties[name].is_a?(Array)
            @properties[name] << value
          else
            @properties[name] = [@properties[name], value]
          end
        else
          @properties[name] = value
        end
      end
    end

  end

end
