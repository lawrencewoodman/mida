require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :TVEpisode, 'mida/vocabularies/schemaorg/tvepisode'
    autoload :TVSeries, 'mida/vocabularies/schemaorg/tvseries'
    autoload :VideoObject, 'mida/vocabularies/schemaorg/videoobject'

    # A TV season.
    class TVSeason < Mida::Vocabulary
      itemtype %r{http://schema.org/TVSeason}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::CreativeWork

      # The end date and time of the event (in ISO 8601 date format).
      has_many 'endDate' do
        extract Mida::DataType::ISO8601Date
      end

      # The episode of a TV series or season.
      has_many 'episodes' do
        extract Mida::SchemaOrg::TVEpisode
        extract Mida::DataType::Text
      end

      # The number of episodes in this season or series.
      has_many 'numberOfEpisodes' do
        extract Mida::DataType::Number
      end

      # The TV series to which this episode or season belongs.
      has_many 'partOfTVSeries' do
        extract Mida::SchemaOrg::TVSeries
        extract Mida::DataType::Text
      end

      # The season number.
      has_many 'seasonNumber' do
        extract Mida::DataType::Integer
      end

      # The start date and time of the event (in ISO 8601 date format).
      has_many 'startDate' do
        extract Mida::DataType::ISO8601Date
      end

      # The trailer of the movie or TV series, season, or episode.
      has_many 'trailer' do
        extract Mida::SchemaOrg::VideoObject
        extract Mida::DataType::Text
      end
    end

  end
end
