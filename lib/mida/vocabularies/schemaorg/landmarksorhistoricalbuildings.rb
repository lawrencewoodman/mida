require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Place, 'mida/vocabularies/schemaorg/place'

    # An historical landmark or building.
    class LandmarksOrHistoricalBuildings < Mida::Vocabulary
      itemtype %r{http://schema.org/LandmarksOrHistoricalBuildings}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Place
    end

  end
end
