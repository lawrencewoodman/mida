require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :WebPage, 'mida/vocabularies/schemaorg/webpage'

    # A page devoted to a single item, such as a particular product or hotel.
    class ItemPage < Mida::Vocabulary
      itemtype %r{http://schema.org/ItemPage}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::CreativeWork
      include_vocabulary Mida::SchemaOrg::WebPage
    end

  end
end
