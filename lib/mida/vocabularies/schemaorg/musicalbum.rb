require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :MusicPlaylist, 'mida/vocabularies/schemaorg/musicplaylist'
    autoload :MusicGroup, 'mida/vocabularies/schemaorg/musicgroup'

    # A collection of music tracks.
    class MusicAlbum < Mida::Vocabulary
      itemtype %r{http://schema.org/MusicAlbum}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::CreativeWork
      include_vocabulary Mida::SchemaOrg::MusicPlaylist

      # The artist that performed this album or recording.
      has_many 'byArtist' do
        extract Mida::SchemaOrg::MusicGroup
        extract Mida::DataType::Text
      end
    end

  end
end
