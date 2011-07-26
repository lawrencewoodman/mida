require 'mida/datatype'

module Mida
  module SchemaOrg

    # The publication format of the book.
    class BookFormatType < Mida::DataType::Enumeration
      VALID_VALUES = [
        [::Mida::DataType::URL, %r{http://schema.org/EBook}i],
        [::Mida::DataType::URL, %r{http://schema.org/Hardcover}i],
        [::Mida::DataType::URL, %r{http://schema.org/Paperback}i]
      ]
    end

  end
end
