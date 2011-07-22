require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :MusicGroup, 'mida/vocabularies/schemaorg/musicgroup'
    autoload :Duration, 'mida/vocabularies/schemaorg/duration'
    autoload :MusicAlbum, 'mida/vocabularies/schemaorg/musicalbum'
    autoload :MusicPlaylist, 'mida/vocabularies/schemaorg/musicplaylist'

    # A music recording (track), usually a single song.
    class MusicRecording < Mida::Vocabulary
      itemtype %r{http://schema.org/MusicRecording}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::CreativeWork

      # The artist that performed this album or recording.
      has_many 'byArtist' do
        extract Mida::SchemaOrg::MusicGroup
        extract Mida::DataType::Text
      end

      # The duration of the item (movie, audio recording, event, etc.) in ISO 8601 date format.
      has_many 'duration' do
        extract Mida::SchemaOrg::Duration
        extract Mida::DataType::Text
      end

      # The album to which this recording belongs.
      has_many 'inAlbum' do
        extract Mida::SchemaOrg::MusicAlbum
        extract Mida::DataType::Text
      end

      # The playlist to which this recording belongs.
      has_many 'inPlaylist' do
        extract Mida::SchemaOrg::MusicPlaylist
        extract Mida::DataType::Text
      end
    end

  end
end
