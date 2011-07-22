require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'

    # Organization: Sports team.
    class SportsTeam < Mida::Vocabulary
      itemtype %r{http://schema.org/SportsTeam}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Organization
    end

  end
end
