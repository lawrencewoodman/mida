require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :MusicAlbum, 'mida/vocabularies/schemaorg/musicalbum'
    autoload :Person, 'mida/vocabularies/schemaorg/person'
    autoload :MusicRecording, 'mida/vocabularies/schemaorg/musicrecording'

    # A musical group, such as a band, an orchestra, or a choir. Can also be a solo musician.
    class MusicGroup < Mida::Vocabulary
      itemtype %r{http://schema.org/MusicGroup}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Organization

      # A collection of music albums.
      has_many 'albums' do
        extract Mida::SchemaOrg::MusicAlbum
        extract Mida::DataType::Text
      end

      # A member of the music group - for example, John, Paul, George, or Ringo.
      has_many 'musicGroupMember' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # A music recording (track) - usually a single song.
      has_many 'tracks' do
        extract Mida::SchemaOrg::MusicRecording
        extract Mida::DataType::Text
      end
    end

  end
end
