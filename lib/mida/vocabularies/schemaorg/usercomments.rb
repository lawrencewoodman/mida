require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Event, 'mida/vocabularies/schemaorg/event'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :Person, 'mida/vocabularies/schemaorg/person'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'

    # User interaction: A comment about an item.
    class UserComments < Mida::Vocabulary
      itemtype %r{http://schema.org/UserComments}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Event

      # The text of the UserComment.
      has_many 'commentText'

      # The time at which the UserComment was made.
      has_many 'commentTime' do
        extract Mida::DataType::ISO8601Date
      end

      # The creator/author of this CreativeWork or UserComments. This is the same as the Author property for CreativeWork.
      has_many 'creator' do
        extract Mida::SchemaOrg::Organization
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # Specifies the CreativeWork associated with the UserComment.
      has_many 'discusses' do
        extract Mida::SchemaOrg::CreativeWork
        extract Mida::DataType::Text
      end

      # The URL at which a reply may be posted to the specified UserComment.
      has_many 'replyToUrl' do
        extract Mida::DataType::URL
      end
    end

  end
end
