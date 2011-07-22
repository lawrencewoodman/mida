require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :AggregateRating, 'mida/vocabularies/schemaorg/aggregaterating'
    autoload :ItemAvailability, 'mida/vocabularies/schemaorg/itemavailability'
    autoload :OfferItemCondition, 'mida/vocabularies/schemaorg/offeritemcondition'
    autoload :Product, 'mida/vocabularies/schemaorg/product'
    autoload :Review, 'mida/vocabularies/schemaorg/review'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'

    # An offer to sell an item - for example, an offer to sell a product, the DVD of a movie, or tickets to an event.
    class Offer < Mida::Vocabulary
      itemtype %r{http://schema.org/Offer}i
      include_vocabulary Mida::SchemaOrg::Thing

      # The overall rating, based on a collection of reviews or ratings, of the item.
      has_many 'aggregateRating' do
        extract Mida::SchemaOrg::AggregateRating
        extract Mida::DataType::Text
      end

      # The availability of this item - for example In stock, Out of stock, Pre-order, etc.
      has_many 'availability' do
        extract Mida::SchemaOrg::ItemAvailability
        extract Mida::DataType::Text
      end

      # The condition of the item for sale - for example New, Refurbished, Used, etc.
      has_many 'itemCondition' do
        extract Mida::SchemaOrg::OfferItemCondition
        extract Mida::DataType::Text
      end

      # The item being sold.
      has_many 'itemOffered' do
        extract Mida::SchemaOrg::Product
        extract Mida::DataType::Text
      end

      # The offer price of the product.
      has_many 'price' do
        extract Mida::DataType::Number
        extract Mida::DataType::Text
      end

      # The currency (in 3-letter ISO 4217 format) of the offer price.
      has_many 'priceCurrency'

      # The date after which the price is no longer available.
      has_many 'priceValidUntil' do
        extract Mida::DataType::ISO8601Date
      end

      # Review of the item.
      has_many 'reviews' do
        extract Mida::SchemaOrg::Review
        extract Mida::DataType::Text
      end

      # The seller of the product.
      has_many 'seller' do
        extract Mida::SchemaOrg::Organization
        extract Mida::DataType::Text
      end
    end

  end
end
