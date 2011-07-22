require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Place, 'mida/vocabularies/schemaorg/place'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :LocalBusiness, 'mida/vocabularies/schemaorg/localbusiness'

    # Financial services business.
    class FinancialService < Mida::Vocabulary
      itemtype %r{http://schema.org/FinancialService}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Place
      include_vocabulary Mida::SchemaOrg::Organization
      include_vocabulary Mida::SchemaOrg::LocalBusiness
    end

  end
end
