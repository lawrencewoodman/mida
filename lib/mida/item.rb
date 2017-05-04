require 'nokogiri'

module Mida

  # Class that holds a validated item
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

    # Create a new Item object from an +Itemscope+ and validates
    # its +properties+
    #
    # [itemscope] The itemscope that has been parsed by +Itemscope+
    def initialize(itemscope)
      @type = itemscope.type
      @id = itemscope.id
      @vocabulary = Mida::Vocabulary.find(@type)
      @properties = itemscope.properties
      validate_properties
    end

    # Return a Hash representation
    # of the form:
    #   { type: 'http://example.com/vocab/review',
    #     id: 'urn:isbn:1-934356-08-5',
    #     properties: {'a name' => 'avalue' }
    #   }
    def to_h
      # Only fill hash with non-nil values
      hash = {}
      @type and hash[:type] = @type
      @id and hash[:id] = @id
      @properties.any? and hash[:properties] = properties_to_h(@properties)
      hash
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
        valid_values = validate_values(property, values)
        if valid_values.respond_to?(:any?)
          hash[property] = valid_values if valid_values.any?
        else
          hash[property] = valid_values
        end
      end
    end

    # Return whether the number of values conforms to +num+
    def valid_num_values?(num, values)
      num == :many || (num == :one && values.length == 1)
    end

    # Return whether this property name is valid
    def valid_property?(property, values)
      [property, :any].any? do |prop|
        @vocabulary.properties.has_key?(prop)
      end
    end

    # Return valid values, converted to the correct +DataType+
    # or +Item+ and number if necessary
    def validate_values(property, values)
      return [] unless valid_property?(property, values)
      prop_num = property_number(property)
      return [] unless valid_num_values?(prop_num, values)
      prop_types = property_types(property)

      valid_values = values.map { |value| validate_value(prop_types, value) }.compact

      # Convert property to correct number
      prop_num == :many ? valid_values : valid_values.first
    end

    # Returns value converted to correct +DataType+ or +Item+
    # or +nil+ if not valid
    def validate_value(prop_types, value)
      if is_itemscope?(value)
        valid_itemtype?(prop_types, value.type) ? Item.new(value) : nil
      elsif (extract_value = datatype_extract(prop_types, value))
        extract_value
      elsif prop_types.include?(:any)
        value
      else
        nil
      end
    end

    # Return the correct type for this property
    def property_types(property)
      if @vocabulary.properties.has_key?(property)
        @vocabulary.properties[property][:types]
      else
        @vocabulary.properties[:any][:types]
      end
    end

    # Return the correct number for this property
    def property_number(property)
      if @vocabulary.properties.has_key?(property)
        @vocabulary.properties[property][:num]
      else
        @vocabulary.properties[:any][:num]
      end
    end

    def is_itemscope?(object)
      object.kind_of?(Itemscope)
    end

    # Returns whether the +itemtype+ is a valid type
    def valid_itemtype?(valid_types, itemtype)
      return true if valid_types.include?(:any)
      vocabulary = Vocabulary.find(itemtype)
      valid_types.find {|type| vocabulary.kind_of?(type) }
    end

    # Returns the extracted value or +nil+ if none of the datatypes
    # could extract the +value+
    def datatype_extract(valid_types, value)
      valid_types.find do |type|
        begin
          return type.parse(value) if type.respond_to?(:parse)
        rescue ArgumentError
        end
      end
      nil
    end

    # The value as it should appear in to_h()
    def value_to_h(value)
      if value.is_a?(Array) then value.collect {|element| value_to_h(element)}
      elsif value.is_a?(Item) then value.to_h
      else value
      end
    end

    def properties_to_h(properties)
      properties.each_with_object({}) do |(name, value), hash|
        hash[name] = value_to_h(value)
      end
    end

  end

end
