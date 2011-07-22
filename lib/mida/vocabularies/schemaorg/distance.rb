require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'

    # Properties that take Distances as values are of the form '<Number> <Length unit of measure>'. E.g., '7 ft'
    class Distance < Mida::Vocabulary
      itemtype %r{http://schema.org/Distance}i
      include_vocabulary Mida::SchemaOrg::Thing
    end

  end
end
