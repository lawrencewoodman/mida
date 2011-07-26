require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :Person, 'mida/vocabularies/schemaorg/person'
    autoload :Duration, 'mida/vocabularies/schemaorg/duration'
    autoload :MusicGroup, 'mida/vocabularies/schemaorg/musicgroup'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :VideoObject, 'mida/vocabularies/schemaorg/videoobject'

    # A movie.
    class Movie < Mida::Vocabulary
      itemtype %r{http://schema.org/Movie}i
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

      # The duration of the item (movie, audio recording, event, etc.) in ISO 8601 date format.
      has_many 'duration' do
        extract Mida::SchemaOrg::Duration
        extract Mida::DataType::Text
      end

      # The composer of the movie or TV soundtrack.
      has_many 'musicBy' do
        extract Mida::SchemaOrg::MusicGroup
        extract Mida::SchemaOrg::Person
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
