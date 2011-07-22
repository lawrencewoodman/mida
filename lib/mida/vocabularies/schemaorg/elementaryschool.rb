require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :EducationalOrganization, 'mida/vocabularies/schemaorg/educationalorganization'

    # An elementary school.
    class ElementarySchool < Mida::Vocabulary
      itemtype %r{http://schema.org/ElementarySchool}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Organization
      include_vocabulary Mida::SchemaOrg::EducationalOrganization
    end

  end
end
