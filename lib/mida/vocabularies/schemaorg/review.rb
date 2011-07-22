require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :Rating, 'mida/vocabularies/schemaorg/rating'

    # A review of an item - for example, a restaurant, movie, or store.
    class Review < Mida::Vocabulary
      itemtype %r{http://schema.org/Review}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::CreativeWork

      # The item that is being reviewed/rated.
      has_many 'itemReviewed' do
        extract Mida::SchemaOrg::Thing
        extract Mida::DataType::Text
      end

      # The actual body of the review
      has_many 'reviewBody'

      # The rating given in this review. Note that reviews can themselves be rated. The reviewRating applies to rating given by the review. The rating property applies to the review itself, as a creative work.
      has_many 'reviewRating' do
        extract Mida::SchemaOrg::Rating
        extract Mida::DataType::Text
      end
    end

  end
end
