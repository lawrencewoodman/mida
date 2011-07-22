require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Place, 'mida/vocabularies/schemaorg/place'
    autoload :CivicStructure, 'mida/vocabularies/schemaorg/civicstructure'

    # Place of worship, such as a church, synagogue, or mosque.
    class PlaceOfWorship < Mida::Vocabulary
      itemtype %r{http://schema.org/PlaceOfWorship}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Place
      include_vocabulary Mida::SchemaOrg::CivicStructure
    end

  end
end
