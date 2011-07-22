require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'

    # Quantities such as distance, time, mass, weight, etc. Particular instances of say Mass are entities like '3 Kg' or '4 milligrams'.
    class Quantity < Mida::Vocabulary
      itemtype %r{http://schema.org/Quantity}i
      include_vocabulary Mida::SchemaOrg::Thing
    end

  end
end
