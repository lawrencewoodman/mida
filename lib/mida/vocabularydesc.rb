require_relative 'propertydesc'

module Mida

  # Class used to describe a vocabulary
  #
  # To specify a vocabulary use the following methods:
  # +itemtype+, +has_one+, +has_many+
  class VocabularyDesc

    def self.inherited(subclass)
      Vocabulary.register(subclass)
    end

    # Sets the regular expression to match against the +itemtype+
    # or returns the current regular expression
    def self.itemtype(regexp_arg=nil)
      if regexp_arg
        @itemtype = regexp_arg
      else
        @itemtype
      end
    end

    # Getter to read the created propeties specification
    def self.prop_spec
      @prop_spec || {}
    end

    # Defines the properties as only containing one value
    # If want to say any property name, then use +:any+ as a name
    # Within a block you can use the methods of the class +PropertyDesc+
    def self.has_one(*property_names, &block)
      has(:one, *property_names, &block)
    end

    # Defines the properties as containing many values
    # If want to say any property name, then use +:any+ as a name
    # Within a block you can use the methods of the class +PropertyDesc+
    def self.has_many(*property_names, &block)
      has(:many, *property_names, &block)
    end

    def self.has(num, *property_names, &block)
      @prop_spec ||= {}
      property_names.each_with_object(@prop_spec) do |name, prop_spec|
        property_desc = PropertyDesc.new(num, &block)
        prop_spec[name] = property_desc.to_h
      end
    end

    private_class_method :has

  end
end
