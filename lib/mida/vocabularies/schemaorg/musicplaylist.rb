require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :MusicRecording, 'mida/vocabularies/schemaorg/musicrecording'

    # A collection of music tracks in playlist form.
    class MusicPlaylist < Mida::Vocabulary
      itemtype %r{http://schema.org/MusicPlaylist}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::CreativeWork

      # The number of tracks in this album or playlist.
      has_many 'numTracks' do
        extract Mida::DataType::Integer
      end

      # A music recording (track) - usually a single song.
      has_many 'tracks' do
        extract Mida::SchemaOrg::MusicRecording
        extract Mida::DataType::Text
      end
    end

  end
end
