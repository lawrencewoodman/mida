module Mida

  # Class used to describe a vocabulary
  #
  # To specify a vocabulary use the following methods:
  # +itemtype+, +has_one+, +has_many+, +types+
  class VocabularyDesc

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

    # The types a property can take. E.g. +String+, or another +Vocabulary+
    # If you want to say any type, then use +:any+ as the class
    # This should be used within a +has_one+ or +has_many+ block
    def self.types(*type_classes)
      {types: type_classes}
    end

    # Defines the properties as only containing one value
    # If want to say any property name, then use +:any+ as a name
    def self.has_one(*property_names, &block)
      has(:one, *property_names, &block)
    end

    # Defines the properties as containing many values
    # If want to say any property name, then use +:any+ as a name
    def self.has_many(*property_names, &block)
      has(:many, *property_names, &block)
    end

    def self.has(num, *property_names, &block)
      @prop_spec ||= {}
      property_names.each_with_object(@prop_spec) do |name, prop_spec|
        prop_spec[name] = if block_given?
          {num: num}.merge(yield)
        else
          {num: num, types: [String]}
        end
      end
    end

    private_class_method :has

  end
end
