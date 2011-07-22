require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'

    # A dance group - for example, the Alvin Ailey Dance Theater or Riverdance.
    class DanceGroup < Mida::Vocabulary
      itemtype %r{http://schema.org/DanceGroup}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Organization
    end

  end
end
