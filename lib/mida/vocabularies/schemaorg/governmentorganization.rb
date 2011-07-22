require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'

    # A governmental organization or agency.
    class GovernmentOrganization < Mida::Vocabulary
      itemtype %r{http://schema.org/GovernmentOrganization}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Organization
    end

  end
end
