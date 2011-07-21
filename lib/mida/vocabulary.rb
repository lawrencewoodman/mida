require 'set'
module Mida

  # Class used to describe a vocabulary
  #
  # To specify a vocabulary use the following methods:
  # +itemtype+, +has_one+, +has_many+
  class Vocabulary

    class << self
      # Return the registered vocabularies
      attr_reader :vocabularies
    end

    @vocabularies = Set.new

    # Register a vocabulary that can be used when parsing,
    # later vocabularies are given precedence over earlier ones
    def self.register(vocabulary)
      @vocabularies << vocabulary
    end

    # Un-register a vocabulary
    def self.unregister(vocabulary)
      @vocabularies.delete(vocabulary)
    end

    # Find the last vocabulary registered that matches the itemtype
    def self.find(itemtype)
      @vocabularies.reverse_each do |vocabulary|
        if ((itemtype || "") =~ vocabulary.itemtype) then return vocabulary end
      end
      nil
    end

    def self.inherited(subclass)
      register(subclass)
    end

    # Return the properties specification
    # This won't work properly until all the included_vocabularies
    # have finished being defined in case of circular dependancies
    def self.properties
      return @properties if @properties
      @properties = @this_properties || {}
      included_vocabularies.each do |vocabulary|
        @properties.merge!(vocabulary.properties)
      end
      @properties
    end

    # Return the included vocabularies
    def self.included_vocabularies
      @included_vocabularies ||= Set.new
    end

    # Specify which +vocabularies+ will have their properties included.
    # This is the correct way to inherit properties from another vocabulary,
    # rather than subclassing.
    def self.include_vocabulary(*vocabularies)
      vocabularies.each do |vocabulary|
        included_vocabularies.merge(vocabulary.included_vocabularies)
        included_vocabularies << vocabulary
      end
    end

    # As per the standard <tt>kind_of?</tt>, but also checks to see if vocabulary has
    # been included by self
    def self.kind_of?(vocabulary)
      return true if self == vocabulary
      return true if self.ancestors.include?(vocabulary)
      included_vocabularies.include?(vocabulary)
    end

    # Sets the regular expression to match against the +itemtype+
    # or returns the current regular expression
    def self.itemtype(regexp=nil)
      return @itemtype unless regexp
      @itemtype = regexp
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
      @this_properties ||= {}
      property_names.each_with_object(@this_properties) do |name, properties|
        property_desc = PropertyDesc.new(num, &block)
        properties[name] = property_desc.to_h
      end
    end

    private_class_method :has

  end
end
