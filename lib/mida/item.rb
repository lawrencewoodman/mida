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
      @itemscope = itemscope
      @page_url, @type = page_url, MiDa.get_itemtype(itemscope)
      @properties = {}
      add_itemref_properties
      add_properties(get_elements(itemscope))
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

    # The value as it should appear in to_h()
    def value_to_h(value)
      case
      when value.is_a?(Array) then value.collect {|element| value_to_h(element)}
      when value.is_a?(Item) then value.to_h
      else value
      end
    end

    # Add any properties referred to by 'itemref'
    def add_itemref_properties
      itemref = get_itemref()
      if itemref
        itemref.split.each {|id| add_properties(find_with_id(id))}
      end
    end

    # Find an element with a matching id
    def find_with_id(id)
      @itemscope.search("//*[@id='#{id}']")
    end

    def properties_to_h(properties)
      hash = {}
      properties.each { |name, value| hash[name] = value_to_h(value) }
      hash
    end

    def get_itemref
      (itemref = @itemscope.attribute('itemref')) ? itemref.value : nil
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

    def add_property(name, value)
      case
      when (!@properties.has_key?(name)) then @properties[name] = value
      when @properties[name].is_a?(Array) then @properties[name] << value
      else @properties[name] = [@properties[name], value]
      end
    end

    def add_itemprop(itemprop)
      properties = Property.parse(itemprop, @page_url)
      properties.each { |name, value| add_property(name, value) }
    end

  end

end
