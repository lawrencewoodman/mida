require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :MediaObject, 'mida/vocabularies/schemaorg/mediaobject'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :ImageObject, 'mida/vocabularies/schemaorg/imageobject'

    # A video file.
    class VideoObject < Mida::Vocabulary
      itemtype %r{http://schema.org/VideoObject}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::CreativeWork
      include_vocabulary Mida::SchemaOrg::MediaObject

      # The caption for this object.
      has_many 'caption'

      # The production company or studio that made the movie, TV series, season, or episode, or video.
      has_many 'productionCompany' do
        extract Mida::SchemaOrg::Organization
        extract Mida::DataType::Text
      end

      # Thumbnail image for an image or video.
      has_many 'thumbnail' do
        extract Mida::SchemaOrg::ImageObject
        extract Mida::DataType::Text
      end

      # If this MediaObject is an AudioObject or VideoObject, the transcript of that object.
      has_many 'transcript'

      # The frame size of the video.
      has_many 'videoFrameSize'

      # The quality of the video.
      has_many 'videoQuality'
    end

  end
end
