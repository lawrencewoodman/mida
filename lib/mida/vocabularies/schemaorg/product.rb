require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :AggregateRating, 'mida/vocabularies/schemaorg/aggregaterating'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :Offer, 'mida/vocabularies/schemaorg/offer'
    autoload :Review, 'mida/vocabularies/schemaorg/review'

    # A product is anything that is made available for sale - for example, a pair of shoes, a concert ticket, or a car.
    class Product < Mida::Vocabulary
      itemtype %r{http://schema.org/Product}i
      include_vocabulary Mida::SchemaOrg::Thing

      # The overall rating, based on a collection of reviews or ratings, of the item.
      has_many 'aggregateRating' do
        extract Mida::SchemaOrg::AggregateRating
        extract Mida::DataType::Text
      end

      # The brand of the product.
      has_many 'brand' do
        extract Mida::SchemaOrg::Organization
        extract Mida::DataType::Text
      end

      # The manufacturer of the product.
      has_many 'manufacturer' do
        extract Mida::SchemaOrg::Organization
        extract Mida::DataType::Text
      end

      # The model of the product.
      has_many 'model'

      # An offer to sell this item - for example, an offer to sell a product, the DVD of a movie, or tickets to an event.
      has_many 'offers' do
        extract Mida::SchemaOrg::Offer
        extract Mida::DataType::Text
      end

      # The product identifier, such as ISBN. For example: <meta itemprop='productID' content='isbn:123-456-789'/>.
      has_many 'productID'

      # Review of the item.
      has_many 'reviews' do
        extract Mida::SchemaOrg::Review
        extract Mida::DataType::Text
      end
    end

  end
end
