require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'

    # The rating of the video.
    class Rating < Mida::Vocabulary
      itemtype %r{http://schema.org/Rating}i
      include_vocabulary Mida::SchemaOrg::Thing

      # The highest value allowed in this rating system. If bestRating is omitted, 5 is assumed.
      has_many 'bestRating' do
        extract Mida::DataType::Number
        extract Mida::DataType::Text
      end

      # The rating for the content.
      has_many 'ratingValue'

      # The lowest value allowed in this rating system. If worstRating is omitted, 1 is assumed.
      has_many 'worstRating' do
        extract Mida::DataType::Number
        extract Mida::DataType::Text
      end
    end

  end
end
