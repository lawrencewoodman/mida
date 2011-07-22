require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Place, 'mida/vocabularies/schemaorg/place'
    autoload :CivicStructure, 'mida/vocabularies/schemaorg/civicstructure'

    # A legislative building - for example, the state capitol.
    class LegislativeBuilding < Mida::Vocabulary
      itemtype %r{http://schema.org/LegislativeBuilding}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Place
      include_vocabulary Mida::SchemaOrg::CivicStructure
    end

  end
end
