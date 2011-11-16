require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'

    # Organization: A business corporation.
    class Corporation < Mida::Vocabulary
      itemtype %r{http://schema.org/Corporation}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Organization

      # The exchange traded instrument associated with a Corporation object. The tickerSymbol is expressed as an exchange and an instrument name separated by a space character. For the exchange component of the tickerSymbol attribute, we reccommend using the controlled vocaulary of Market Identifier Codes (MIC) specified in ISO15022.
      has_many 'tickerSymbol'
    end

  end
end
