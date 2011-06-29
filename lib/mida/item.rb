require 'nokogiri'
require 'mida'

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
      {type: @type, id: @id, properties: properties_to_h(@properties)}
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
        hash[property] = valid_values unless valid_values.nil?
      end
    end

    # Return whether the number of values conforms to +num+
    def valid_num_values?(num, values)
      num == :many || (num == :one && values.length == 1)
    end

    # Return whether this property name is valid
    def valid_property?(property, values)
      [property, :any].any? do |prop|
        @vocabulary.prop_spec.has_key?(prop)
      end
    end

    # Return valid values, converted to the correct +DataType+
    # or +Item+ and number if necessary
    def validate_values(property, values)
      return nil unless valid_property?(property, values)
      prop_num = property_number(property)
      return nil unless valid_num_values?(prop_num, values)
      prop_types = property_types(property)

      valid_values = values.each_with_object([]) do |value, valid_values|
        new_value = validate_value(prop_types, value)
        valid_values << new_value unless new_value.nil?
      end

      # Convert property to correct number
      prop_num == :many ? valid_values : valid_values.first
    end

    # Returns value, converted to correct +DataType+ or +Item+
    def validate_value(prop_types, value)
      valid_value = nil
      if is_itemscope?(value)
        if valid_itemtype?(prop_types, value.type)
          valid_value = Item.new(value)
        end
      elsif (type = valid_datatype?(prop_types, value))
        valid_value = type.extract(value)
      elsif prop_types.include?(:any)
        valid_value = value
      end
      valid_value
    end

    # Return the correct type for this property
    def property_types(property)
      if @vocabulary.prop_spec.has_key?(property)
        @vocabulary.prop_spec[property][:types]
      else
        @vocabulary.prop_spec[:any][:types]
      end
    end

    # Return the correct number for this property
    def property_number(property)
      if @vocabulary.prop_spec.has_key?(property)
        @vocabulary.prop_spec[property][:num]
      else
        @vocabulary.prop_spec[:any][:num]
      end
    end

    def is_itemscope?(object)
      object.kind_of?(Itemscope)
    end

    # Returns whether the +itemtype+ is a valid type
    def valid_itemtype?(valid_types, itemtype)
      return true if valid_types.include?(:any)

      valid_types.find do |type|
        type.respond_to?(:itemtype) && type.itemtype =~ itemtype
      end
    end

    # Returns the valid type of the +value+ or +nil+ if not valid
    def valid_datatype?(valid_types, value)
      valid_types.find do |type|
        type.respond_to?(:valid?) && type.valid?(value)
      end
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

  end

end
