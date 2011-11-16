require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'

    # The geographic shape of a place.
    class GeoShape < Mida::Vocabulary
      itemtype %r{http://schema.org/GeoShape}i
      include_vocabulary Mida::SchemaOrg::Thing

      # A polygon is the area enclosed by a point-to-point path for which the starting and ending points are the same. A polygon is expressed as a series of four or more spacedelimited points where the first and final points are identical.
      has_many 'box'

      # A circle is the circular region of a specified radius centered at a specified latitude and longitude. A circle is expressed as a pair followed by a radius in meters.
      has_many 'circle'

      # The elevation of a location.
      has_many 'elevation' do
        extract Mida::DataType::Number
        extract Mida::DataType::Text
      end

      # A line is a point-to-point path consisting of two or more points. A line is expressed as a series of two or more point objects separated by space.
      has_many 'line'

      # A polygon is the area enclosed by a point-to-point path for which the starting and ending points are the same. A polygon is expressed as a series of four or more spacedelimited points where the first and final points are identical.
      has_many 'polygon'
    end

  end
end
