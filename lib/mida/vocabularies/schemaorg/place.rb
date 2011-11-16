require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :PostalAddress, 'mida/vocabularies/schemaorg/postaladdress'
    autoload :AggregateRating, 'mida/vocabularies/schemaorg/aggregaterating'
    autoload :Place, 'mida/vocabularies/schemaorg/place'
    autoload :Event, 'mida/vocabularies/schemaorg/event'
    autoload :GeoCoordinates, 'mida/vocabularies/schemaorg/geocoordinates'
    autoload :GeoShape, 'mida/vocabularies/schemaorg/geoshape'
    autoload :ImageObject, 'mida/vocabularies/schemaorg/imageobject'
    autoload :Photograph, 'mida/vocabularies/schemaorg/photograph'
    autoload :Review, 'mida/vocabularies/schemaorg/review'

    # Entities that have a somewhat fixed, physical extension.
    class Place < Mida::Vocabulary
      itemtype %r{http://schema.org/Place}i
      include_vocabulary Mida::SchemaOrg::Thing

      # Physical address of the item.
      has_many 'address' do
        extract Mida::SchemaOrg::PostalAddress
        extract Mida::DataType::Text
      end

      # The overall rating, based on a collection of reviews or ratings, of the item.
      has_many 'aggregateRating' do
        extract Mida::SchemaOrg::AggregateRating
        extract Mida::DataType::Text
      end

      # The basic containment relation between places.
      has_many 'containedIn' do
        extract Mida::SchemaOrg::Place
        extract Mida::DataType::Text
      end

      # Upcoming or past events associated with this place or organization.
      has_many 'events' do
        extract Mida::SchemaOrg::Event
        extract Mida::DataType::Text
      end

      # The fax number.
      has_many 'faxNumber'

      # The geo coordinates of the place.
      has_many 'geo' do
        extract Mida::SchemaOrg::GeoCoordinates
        extract Mida::SchemaOrg::GeoShape
        extract Mida::DataType::Text
      end

      # A count of a specific user interactions with this item - for example, 20 UserLikes, 5 UserComments, or 300 UserDownloads. The user interaction type should be one of the sub types of UserInteraction.
      has_many 'interactionCount'

      # A URL to a map of the place.
      has_many 'maps' do
        extract Mida::DataType::URL
      end

      # Photographs of this place.
      has_many 'photos' do
        extract Mida::SchemaOrg::ImageObject
        extract Mida::SchemaOrg::Photograph
        extract Mida::DataType::Text
      end

      # Review of the item.
      has_many 'reviews' do
        extract Mida::SchemaOrg::Review
        extract Mida::DataType::Text
      end

      # The telephone number.
      has_many 'telephone'
    end

  end
end
