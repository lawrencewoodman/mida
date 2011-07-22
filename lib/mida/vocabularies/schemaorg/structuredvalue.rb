require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'

    # Structured values are strings - for example, addresses - that have certain constraints on their structure.
    class StructuredValue < Mida::Vocabulary
      itemtype %r{http://schema.org/StructuredValue}i
      include_vocabulary Mida::SchemaOrg::Thing
    end

  end
end
