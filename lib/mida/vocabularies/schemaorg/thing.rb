require 'mida/vocabulary'

module Mida
  module SchemaOrg


    # The most generic type of item.
    class Thing < Mida::Vocabulary
      itemtype %r{http://schema.org/Thing}i

      # A short description of the item.
      has_many 'description'

      # URL of an image of the item.
      has_many 'image' do
        extract Mida::DataType::URL
      end

      # The name of the item.
      has_many 'name'

      # URL of the item.
      has_many 'url' do
        extract Mida::DataType::URL
      end
    end

  end
end
