require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :NewsArticle, 'mida/vocabularies/schemaorg/newsarticle'
    autoload :Duration, 'mida/vocabularies/schemaorg/duration'
    autoload :Distance, 'mida/vocabularies/schemaorg/distance'
    autoload :Place, 'mida/vocabularies/schemaorg/place'

    # An image, video, or audio object embedded in a web page. Note that a creative work may have many media objects associated with it on the same web page. For example, a page about a single song (MusicRecording) may have a music video (VideoObject), and a high and low bandwidth audio stream (2 AudioObject's).
    class MediaObject < Mida::Vocabulary
      itemtype %r{http://schema.org/MediaObject}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::CreativeWork

      # A NewsArticle associated with the Media Object.
      has_many 'associatedArticle' do
        extract Mida::SchemaOrg::NewsArticle
        extract Mida::DataType::Text
      end

      # The bitrate of the media object.
      has_many 'bitrate'

      # File size in (mega/kilo) bytes.
      has_many 'contentSize'

      # Actual bytes of the media object, for example the image file or video file.
      has_many 'contentURL' do
        extract Mida::DataType::URL
      end

      # The duration of the item (movie, audio recording, event, etc.) in ISO 8601 date format.
      has_many 'duration' do
        extract Mida::SchemaOrg::Duration
        extract Mida::DataType::Text
      end

      # A URL pointing to a player for a specific video. In general, this is the information in the src element of an embed tag and should not be the same as the content of the loc tag.
      has_many 'embedURL' do
        extract Mida::DataType::URL
      end

      # The creative work encoded by this media object
      has_many 'encodesCreativeWork' do
        extract Mida::SchemaOrg::CreativeWork
        extract Mida::DataType::Text
      end

      # mp3, mpeg4, etc.
      has_many 'encodingFormat'

      # Date the content expires and is no longer useful or available. Useful for videos.
      has_many 'expires' do
        extract Mida::DataType::ISO8601Date
      end

      # The height of the media object.
      has_many 'height' do
        extract Mida::SchemaOrg::Distance
        extract Mida::DataType::Text
      end

      # Player type required - for example, Flash or Silverlight.
      has_many 'playerType'

      # The regions where the media is allowed. If not specified, then it's assumed to be allowed everywhere. Specify the countries in ISO 3166 format.
      has_many 'regionsAllowed' do
        extract Mida::SchemaOrg::Place
        extract Mida::DataType::Text
      end

      # Indicates if use of the media require a subscription  (either paid or free). Allowed values are yes or no.
      has_many 'requiresSubscription' do
        extract Mida::DataType::Boolean
      end

      # Date when this media object was uploaded to this site.
      has_many 'uploadDate' do
        extract Mida::DataType::ISO8601Date
      end

      # The width of the media object.
      has_many 'width' do
        extract Mida::SchemaOrg::Distance
        extract Mida::DataType::Text
      end
    end

  end
end
