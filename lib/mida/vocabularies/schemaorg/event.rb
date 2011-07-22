require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Person, 'mida/vocabularies/schemaorg/person'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :Duration, 'mida/vocabularies/schemaorg/duration'
    autoload :Place, 'mida/vocabularies/schemaorg/place'
    autoload :PostalAddress, 'mida/vocabularies/schemaorg/postaladdress'
    autoload :Offer, 'mida/vocabularies/schemaorg/offer'
    autoload :Event, 'mida/vocabularies/schemaorg/event'

    # An event happening at a certain time at a certain location.
    class Event < Mida::Vocabulary
      itemtype %r{http://schema.org/Event}i
      include_vocabulary Mida::SchemaOrg::Thing

      # A person attending the event.
      has_many 'attendees' do
        extract Mida::SchemaOrg::Person
        extract Mida::SchemaOrg::Organization
        extract Mida::DataType::Text
      end

      # The duration of the item (movie, audio recording, event, etc.) in ISO 8601 date format.
      has_many 'duration' do
        extract Mida::SchemaOrg::Duration
        extract Mida::DataType::Text
      end

      # The end date and time of the event (in ISO 8601 date format).
      has_many 'endDate' do
        extract Mida::DataType::ISO8601Date
      end

      # The location of the event or organization.
      has_many 'location' do
        extract Mida::SchemaOrg::Place
        extract Mida::SchemaOrg::PostalAddress
        extract Mida::DataType::Text
      end

      # An offer to sell this item - for example, an offer to sell a product, the DVD of a movie, or tickets to an event.
      has_many 'offers' do
        extract Mida::SchemaOrg::Offer
        extract Mida::DataType::Text
      end

      # The main performer or performers of the event - for example, a presenter, musician, or actor.
      has_many 'performers' do
        extract Mida::SchemaOrg::Person
        extract Mida::SchemaOrg::Organization
        extract Mida::DataType::Text
      end

      # The start date and time of the event (in ISO 8601 date format).
      has_many 'startDate' do
        extract Mida::DataType::ISO8601Date
      end

      # Events that are a part of this event. For example, a conference event includes many presentations, each are subEvents of the conference.
      has_many 'subEvents' do
        extract Mida::SchemaOrg::Event
        extract Mida::DataType::Text
      end

      # An event that this event is a part of. For example, a collection of individual music performances might each have a music festival as their superEvent.
      has_many 'superEvent' do
        extract Mida::SchemaOrg::Event
        extract Mida::DataType::Text
      end
    end

  end
end
