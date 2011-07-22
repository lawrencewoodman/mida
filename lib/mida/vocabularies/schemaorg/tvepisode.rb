require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :Person, 'mida/vocabularies/schemaorg/person'
    autoload :MusicGroup, 'mida/vocabularies/schemaorg/musicgroup'
    autoload :TVSeason, 'mida/vocabularies/schemaorg/tvseason'
    autoload :TVSeries, 'mida/vocabularies/schemaorg/tvseries'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :VideoObject, 'mida/vocabularies/schemaorg/videoobject'

    # An episode of a TV series or season.
    class TVEpisode < Mida::Vocabulary
      itemtype %r{http://schema.org/TVEpisode}i
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

      # The episode number.
      has_many 'episodeNumber' do
        extract Mida::DataType::Number
      end

      # The composer of the movie or TV soundtrack.
      has_many 'musicBy' do
        extract Mida::SchemaOrg::Person
        extract Mida::SchemaOrg::MusicGroup
        extract Mida::DataType::Text
      end

      # The season to which this episode belongs.
      has_many 'partOfSeason' do
        extract Mida::SchemaOrg::TVSeason
        extract Mida::DataType::Text
      end

      # The TV series to which this episode or season belongs.
      has_many 'partOfTVSeries' do
        extract Mida::SchemaOrg::TVSeries
        extract Mida::DataType::Text
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

      # The trailer of the movie or TV series, season, or episode.
      has_many 'trailer' do
        extract Mida::SchemaOrg::VideoObject
        extract Mida::DataType::Text
      end
    end

  end
end
