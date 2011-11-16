require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Person, 'mida/vocabularies/schemaorg/person'
    autoload :AggregateRating, 'mida/vocabularies/schemaorg/aggregaterating'
    autoload :MediaObject, 'mida/vocabularies/schemaorg/mediaobject'
    autoload :AudioObject, 'mida/vocabularies/schemaorg/audioobject'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :UserComments, 'mida/vocabularies/schemaorg/usercomments'
    autoload :Place, 'mida/vocabularies/schemaorg/place'
    autoload :Offer, 'mida/vocabularies/schemaorg/offer'
    autoload :Review, 'mida/vocabularies/schemaorg/review'
    autoload :VideoObject, 'mida/vocabularies/schemaorg/videoobject'

    # The most generic kind of creative work, including books, movies, photographs, software programs, etc.
    class CreativeWork < Mida::Vocabulary
      itemtype %r{http://schema.org/CreativeWork}i
      include_vocabulary Mida::SchemaOrg::Thing

      # The subject matter of the content.
      has_many 'about' do
        extract Mida::SchemaOrg::Thing
        extract Mida::DataType::Text
      end

      # Specifies the Person that is legally accountable for the CreativeWork.
      has_many 'accountablePerson' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # The overall rating, based on a collection of reviews or ratings, of the item.
      has_many 'aggregateRating' do
        extract Mida::SchemaOrg::AggregateRating
        extract Mida::DataType::Text
      end

      # A secondary title of the CreativeWork.
      has_many 'alternativeHeadline'

      # The media objects that encode this creative work. This property is a synonym for encodings.
      has_many 'associatedMedia' do
        extract Mida::SchemaOrg::MediaObject
        extract Mida::DataType::Text
      end

      # An embedded audio object.
      has_many 'audio' do
        extract Mida::SchemaOrg::AudioObject
        extract Mida::DataType::Text
      end

      # The author of this content. Please note that author is special in that HTML 5 provides a special mechanism for indicating authorship via the rel tag. That is equivalent to this and may be used interchangabely.
      has_many 'author' do
        extract Mida::SchemaOrg::Organization
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # Awards won by this person or for this creative work.
      has_many 'awards'

      # Comments, typically from users, on this CreativeWork.
      has_many 'comment' do
        extract Mida::SchemaOrg::UserComments
        extract Mida::DataType::Text
      end

      # The location of the content.
      has_many 'contentLocation' do
        extract Mida::SchemaOrg::Place
        extract Mida::DataType::Text
      end

      # Official rating of a piece of content - for example,'MPAA PG-13'.
      has_many 'contentRating'

      # A secondary contributor to the CreativeWork.
      has_many 'contributor' do
        extract Mida::SchemaOrg::Organization
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # The party holding the legal copyright to the CreativeWork.
      has_many 'copyrightHolder' do
        extract Mida::SchemaOrg::Organization
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # The year during which the claimed copyright for the CreativeWork was first asserted.
      has_many 'copyrightYear' do
        extract Mida::DataType::Number
      end

      # The creator/author of this CreativeWork or UserComments. This is the same as the Author property for CreativeWork.
      has_many 'creator' do
        extract Mida::SchemaOrg::Organization
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # The date on which the CreativeWork was created.
      has_many 'dateCreated' do
        extract Mida::DataType::ISO8601Date
      end

      # The date on which the CreativeWork was most recently modified.
      has_many 'dateModified' do
        extract Mida::DataType::ISO8601Date
      end

      # Date of first broadcast/publication.
      has_many 'datePublished' do
        extract Mida::DataType::ISO8601Date
      end

      # A link to the page containing the comments of the CreativeWork.
      has_many 'discussionUrl' do
        extract Mida::DataType::URL
      end

      # Specifies the Person who edited the CreativeWork.
      has_many 'editor' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # The media objects that encode this creative work
      has_many 'encodings' do
        extract Mida::SchemaOrg::MediaObject
        extract Mida::DataType::Text
      end

      # Genre of the creative work
      has_many 'genre'

      # Headline of the article
      has_many 'headline'

      # The language of the content. please use one of the language codes from the IETF BCP 47 standard.
      has_many 'inLanguage'

      # A count of a specific user interactions with this item - for example, 20 UserLikes, 5 UserComments, or 300 UserDownloads. The user interaction type should be one of the sub types of UserInteraction.
      has_many 'interactionCount'

      # Indicates whether this content is family friendly.
      has_many 'isFamilyFriendly' do
        extract Mida::DataType::Boolean
      end

      # The keywords/tags used to describe this content.
      has_many 'keywords'

      # Indicates that the CreativeWork contains a reference to, but is not necessarily about a concept.
      has_many 'mentions' do
        extract Mida::SchemaOrg::Thing
        extract Mida::DataType::Text
      end

      # An offer to sell this item - for example, an offer to sell a product, the DVD of a movie, or tickets to an event.
      has_many 'offers' do
        extract Mida::SchemaOrg::Offer
        extract Mida::DataType::Text
      end

      # Specifies the Person or Organization that distributed the CreativeWork.
      has_many 'provider' do
        extract Mida::SchemaOrg::Organization
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # The publisher of the creative work.
      has_many 'publisher' do
        extract Mida::SchemaOrg::Organization
        extract Mida::DataType::Text
      end

      # Link to page describing the editorial principles of the organization primarily responsible for the creation of the CreativeWork.
      has_many 'publishingPrinciples' do
        extract Mida::DataType::URL
      end

      # Review of the item.
      has_many 'reviews' do
        extract Mida::SchemaOrg::Review
        extract Mida::DataType::Text
      end

      # The Organization on whose behalf the creator was working.
      has_many 'sourceOrganization' do
        extract Mida::SchemaOrg::Organization
        extract Mida::DataType::Text
      end

      # A thumbnail image relevant to the Thing.
      has_many 'thumbnailUrl' do
        extract Mida::DataType::URL
      end

      # The version of the CreativeWork embodied by a specified resource.
      has_many 'version' do
        extract Mida::DataType::Number
      end

      # An embedded video object.
      has_many 'video' do
        extract Mida::SchemaOrg::VideoObject
        extract Mida::DataType::Text
      end
    end

  end
end
