require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'

    # The publication format of the book.
    class BookFormatType < Mida::Vocabulary
      itemtype %r{http://schema.org/BookFormatType}i
      include_vocabulary Mida::SchemaOrg::Thing
    end

  end
end
