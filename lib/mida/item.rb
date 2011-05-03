require 'nokogiri'

module Mida

  # Class that holds each item/itemscope
  class Item
    # The vocabulary used to interpret this item
    attr_reader :vocabulary

    # The Type of the item
    attr_reader :type

    # The Global Identifier of the item
    attr_reader :id

    # A Hash representing the properties as name/values paris
    # The values will be an array containing either +String+
    # or <tt>Mida::Item</tt> instances
    attr_reader :properties

    # Create a new Item object
    #
    # [itemscope] The itemscope that you want to parse.
    # [page_url] The url of target used for form absolute url.
    def initialize(itemscope, page_url=nil)
      @itemscope, @page_url = itemscope, page_url
      @type, @id = extract_attribute('itemtype'), extract_attribute('itemid')
      @vocabulary = Mida::Vocabulary.find_vocabulary(@type)
      @properties = {}
      add_itemref_properties
      parse_elements(extract_elements(@itemscope))
      validate_properties
    end

    # Return a Hash representation
    # of the form:
    #   { vocabulary: 'http://example.com/vocab/review',
    #     type: 'The item type',
    #     id: 'urn:isbn:1-934356-08-5',
    #     properties: {'a name' => 'avalue' }
    #   }
    def to_h
      {vocabulary: @vocabulary, type: @type, id: @id, properties: properties_to_h(@properties)}
    end

    def to_s
      to_h.to_s
    end

    def ==(other)
      @vocabulary == other.vocabulary && @type == other.type &&
      @id == other.id && @properties == other.properties
    end

  private

    # Validate the properties so that they are in their proper form
    def validate_properties
      @properties =
      @properties.each_with_object({}) do |(property, values), hash|
        if valid_property?(property, values)
          hash[property] = valid_values(property, values)
        end
      end
    end

    # Return whether the number of values conforms to the spec
    def valid_num_values?(property, values)
      return false unless @vocabulary.prop_spec.has_key?(property)
      property_spec = @vocabulary.prop_spec[property]
      (property_spec[:num] == :many ||
        (property_spec[:num] == :one && values.length == 1))
    end

    def valid_property?(property, values)
      [property, :any].any? {|prop| valid_num_values?(prop, values)}
    end

    def valid_values(property, values)
      prop_types = if @vocabulary.prop_spec.has_key?(property)
        @vocabulary.prop_spec[property][:types]
      else
        @vocabulary.prop_spec[:any][:types]
      end

      values.select {|value| valid_type(prop_types, value) }
    end

    def valid_type(prop_types, value)
      if value.respond_to?(:vocabulary)
        if prop_types.include?(value.vocabulary) || prop_types.include?(:any)
          return true
        end
      elsif prop_types.include?(value.class) || prop_types.include?(:any)
        return true
      end
      false
    end

    def extract_attribute(attribute)
      (value = @itemscope.attribute(attribute)) ? value.value : nil
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
      properties.each_with_object({}) do |(name, value), hash|
        hash[name] = value_to_h(value)
      end
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

    def add_itemprop(itemprop)
      properties = Itemprop.parse(itemprop, @page_url)
      properties.each { |name, value| (@properties[name] ||= []) << value }
    end

  end

end
