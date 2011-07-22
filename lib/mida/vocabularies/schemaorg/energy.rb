require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'

    # Properties that take Enerygy as values are of the form '<Number> <Energy unit of measure>'
    class Energy < Mida::Vocabulary
      itemtype %r{http://schema.org/Energy}i
      include_vocabulary Mida::SchemaOrg::Thing
    end

  end
end
