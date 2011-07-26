require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :PostalAddress, 'mida/vocabularies/schemaorg/postaladdress'
    autoload :AggregateRating, 'mida/vocabularies/schemaorg/aggregaterating'
    autoload :ContactPoint, 'mida/vocabularies/schemaorg/contactpoint'
    autoload :Person, 'mida/vocabularies/schemaorg/person'
    autoload :Event, 'mida/vocabularies/schemaorg/event'
    autoload :Place, 'mida/vocabularies/schemaorg/place'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :Review, 'mida/vocabularies/schemaorg/review'

    # An organization such as a school, NGO, corporation, club, etc.
    class Organization < Mida::Vocabulary
      itemtype %r{http://schema.org/Organization}i
      include_vocabulary Mida::SchemaOrg::Thing

      # Physical address of the item.
      has_many 'address' do
        extract Mida::SchemaOrg::PostalAddress
        extract Mida::DataType::Text
      end

      # The overall rating, based on a collection of reviews or ratings, of the item.
      has_many 'aggregateRating' do
        extract Mida::SchemaOrg::AggregateRating
        extract Mida::DataType::Text
      end

      # A contact point for a person or organization.
      has_many 'contactPoints' do
        extract Mida::SchemaOrg::ContactPoint
        extract Mida::DataType::Text
      end

      # Email address.
      has_many 'email'

      # People working for this organization.
      has_many 'employees' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # The events held at this place or organization.
      has_many 'events' do
        extract Mida::SchemaOrg::Event
        extract Mida::DataType::Text
      end

      # The fax number.
      has_many 'faxNumber'

      # A person who founded this organization.
      has_many 'founders' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # The date that this organization was founded.
      has_many 'foundingDate' do
        extract Mida::DataType::ISO8601Date
      end

      # A count of a specific user interactions with this item - for example, 20 UserLikes, 5 UserComments, or 300 UserDownloads. The user interaction type should be one of the sub types of UserInteraction.
      has_many 'interactionCount'

      # The location of the event or organization.
      has_many 'location' do
        extract Mida::SchemaOrg::Place
        extract Mida::SchemaOrg::PostalAddress
        extract Mida::DataType::Text
      end

      # A member of this organization.
      has_many 'members' do
        extract Mida::SchemaOrg::Organization
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # Review of the item.
      has_many 'reviews' do
        extract Mida::SchemaOrg::Review
        extract Mida::DataType::Text
      end

      # The telephone number.
      has_many 'telephone'
    end

  end
end
