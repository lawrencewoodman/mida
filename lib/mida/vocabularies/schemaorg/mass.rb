require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'

    # Properties that take Mass as values are of the form '<Number> <Mass unit of measure>'. E.g., '7 kg'
    class Mass < Mida::Vocabulary
      itemtype %r{http://schema.org/Mass}i
      include_vocabulary Mida::SchemaOrg::Thing
    end

  end
end
