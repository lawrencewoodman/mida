require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'

    # A list of possible conditions for the item for sale.
    class OfferItemCondition < Mida::Vocabulary
      itemtype %r{http://schema.org/OfferItemCondition}i
      include_vocabulary Mida::SchemaOrg::Thing
    end

  end
end
