require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'

    # A list of possible product availablity options.
    class ItemAvailability < Mida::Vocabulary
      itemtype %r{http://schema.org/ItemAvailability}i
      include_vocabulary Mida::SchemaOrg::Thing
    end

  end
end
