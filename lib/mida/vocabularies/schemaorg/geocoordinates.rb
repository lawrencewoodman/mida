require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'

    # The geographic coordinates of a place or event.
    class GeoCoordinates < Mida::Vocabulary
      itemtype %r{http://schema.org/GeoCoordinates}i
      include_vocabulary Mida::SchemaOrg::Thing

      # The elevation of a location.
      has_many 'elevation' do
        extract Mida::DataType::Number
        extract Mida::DataType::Text
      end

      # The latitude of a location. For example 37.42242.
      has_many 'latitude' do
        extract Mida::DataType::Number
        extract Mida::DataType::Text
      end

      # The longitude of a location. For example -122.08585.
      has_many 'longitude' do
        extract Mida::DataType::Number
        extract Mida::DataType::Text
      end
    end

  end
end
