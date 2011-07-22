require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :Person, 'mida/vocabularies/schemaorg/person'
    autoload :TVEpisode, 'mida/vocabularies/schemaorg/tvepisode'
    autoload :MusicGroup, 'mida/vocabularies/schemaorg/musicgroup'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :TVSeason, 'mida/vocabularies/schemaorg/tvseason'
    autoload :VideoObject, 'mida/vocabularies/schemaorg/videoobject'

    # A television series.
    class TVSeries < Mida::Vocabulary
      itemtype %r{http://schema.org/TVSeries}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::CreativeWork

      # A cast member of the movie, TV series, season, or episode, or video.
      has_many 'actors' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # The director of the movie, TV episode, or series.
      has_many 'director' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # The end date and time of the event (in ISO 8601 date format).
      has_many 'endDate' do
        extract Mida::DataType::ISO8601Date
      end

      # The episode of a TV series or season.
      has_many 'episodes' do
        extract Mida::SchemaOrg::TVEpisode
        extract Mida::DataType::Text
      end

      # The composer of the movie or TV soundtrack.
      has_many 'musicBy' do
        extract Mida::SchemaOrg::Person
        extract Mida::SchemaOrg::MusicGroup
        extract Mida::DataType::Text
      end

      # The number of episodes in this season or series.
      has_many 'numberOfEpisodes' do
        extract Mida::DataType::Number
      end

      # The producer of the movie, TV series, season, or episode, or video.
      has_many 'producer' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # The production company or studio that made the movie, TV series, season, or episode, or video.
      has_many 'productionCompany' do
        extract Mida::SchemaOrg::Organization
        extract Mida::DataType::Text
      end

      # The seasons of the TV series.
      has_many 'seasons' do
        extract Mida::SchemaOrg::TVSeason
        extract Mida::DataType::Text
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
