require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :BookFormatType, 'mida/vocabularies/schemaorg/bookformattype'
    autoload :Person, 'mida/vocabularies/schemaorg/person'

    # A book.
    class Book < Mida::Vocabulary
      itemtype %r{http://schema.org/Book}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::CreativeWork

      # The edition of the book.
      has_many 'bookEdition'

      # The format of the book.
      has_many 'bookFormat' do
        extract Mida::SchemaOrg::BookFormatType
        extract Mida::DataType::Text
      end

      # The illustrator of the book.
      has_many 'illustrator' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # The ISBN of the book.
      has_many 'isbn'

      # The number of pages in the book.
      has_many 'numberOfPages' do
        extract Mida::DataType::Integer
      end
    end

  end
end
