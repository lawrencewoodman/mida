require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :EducationalOrganization, 'mida/vocabularies/schemaorg/educationalorganization'

    # A preschool.
    class Preschool < Mida::Vocabulary
      itemtype %r{http://schema.org/Preschool}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Organization
      include_vocabulary Mida::SchemaOrg::EducationalOrganization
    end

  end
end
