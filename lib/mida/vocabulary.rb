module Mida

  # Module to register the Vocabularies with
  module Vocabulary

    # Register a vocabulary that can be used when parsing,
    # later vocabularies are given precedence over earlier ones
    def self.register_vocabulary(vocabulary)
      (@vocabularies ||= []) << vocabulary
    end

    # Find the last vocabulary registered that matches the itemtype
    def self.find_vocabulary(itemtype)
      @vocabularies.reverse_each do |vocabulary|
        if ((itemtype || "") =~ vocabulary.itemtype) then return vocabulary end
      end
      nil
    end

    # Return the registered vocabularies
    def self.vocabularies
      @vocabularies
    end

  end
end
