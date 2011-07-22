require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Place, 'mida/vocabularies/schemaorg/place'

    # A geographical region under the jurisdiction of a particular government.
    class AdministrativeArea < Mida::Vocabulary
      itemtype %r{http://schema.org/AdministrativeArea}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Place
    end

  end
end
