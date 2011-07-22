require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :Person, 'mida/vocabularies/schemaorg/person'

    # An educational organization.
    class EducationalOrganization < Mida::Vocabulary
      itemtype %r{http://schema.org/EducationalOrganization}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Organization

      # Alumni of educational organization.
      has_many 'alumni' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end
    end

  end
end
