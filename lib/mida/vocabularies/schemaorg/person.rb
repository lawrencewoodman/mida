require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :PostalAddress, 'mida/vocabularies/schemaorg/postaladdress'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :EducationalOrganization, 'mida/vocabularies/schemaorg/educationalorganization'
    autoload :Person, 'mida/vocabularies/schemaorg/person'
    autoload :ContactPoint, 'mida/vocabularies/schemaorg/contactpoint'
    autoload :Place, 'mida/vocabularies/schemaorg/place'
    autoload :Country, 'mida/vocabularies/schemaorg/country'
    autoload :Event, 'mida/vocabularies/schemaorg/event'

    # A person (alive, dead, undead, or fictional).
    class Person < Mida::Vocabulary
      itemtype %r{http://schema.org/Person}i
      include_vocabulary Mida::SchemaOrg::Thing

      # Physical address of the item.
      has_many 'address' do
        extract Mida::SchemaOrg::PostalAddress
        extract Mida::DataType::Text
      end

      # An organization that this person is affiliated with. For example, a school/university, a club, or a team.
      has_many 'affiliation' do
        extract Mida::SchemaOrg::Organization
        extract Mida::DataType::Text
      end

      # An educational organizations that the person is an alumni of.
      has_many 'alumniOf' do
        extract Mida::SchemaOrg::EducationalOrganization
        extract Mida::DataType::Text
      end

      # Awards won by this person or for this creative work.
      has_many 'awards'

      # Date of birth.
      has_many 'birthDate' do
        extract Mida::DataType::ISO8601Date
      end

      # A child of the person.
      has_many 'children' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # A colleague of the person.
      has_many 'colleagues' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # A contact point for a person or organization.
      has_many 'contactPoints' do
        extract Mida::SchemaOrg::ContactPoint
        extract Mida::DataType::Text
      end

      # Date of death.
      has_many 'deathDate' do
        extract Mida::DataType::ISO8601Date
      end

      # Email address.
      has_many 'email'

      # The fax number.
      has_many 'faxNumber'

      # The most generic uni-directional social relation.
      has_many 'follows' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # Gender of the person.
      has_many 'gender'

      # A contact location for a person's residence.
      has_many 'homeLocation' do
        extract Mida::SchemaOrg::Place
        extract Mida::SchemaOrg::ContactPoint
        extract Mida::DataType::Text
      end

      # A count of a specific user interactions with this item - for example, 20 UserLikes, 5 UserComments, or 300 UserDownloads. The user interaction type should be one of the sub types of UserInteraction.
      has_many 'interactionCount'

      # The job title of the person (for example, Financial Manager).
      has_many 'jobTitle'

      # The most generic bi-directional social/work relation.
      has_many 'knows' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # An organization to which the person belongs.
      has_many 'memberOf' do
        extract Mida::SchemaOrg::Organization
        extract Mida::DataType::Text
      end

      # Nationality of the person.
      has_many 'nationality' do
        extract Mida::SchemaOrg::Country
        extract Mida::DataType::Text
      end

      # A parents of the person.
      has_many 'parents' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # Event that this person is a performer or participant in.
      has_many 'performerIn' do
        extract Mida::SchemaOrg::Event
        extract Mida::DataType::Text
      end

      # The most generic familial relation.
      has_many 'relatedTo' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # A sibling of the person.
      has_many 'siblings' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # The person's spouse.
      has_many 'spouse' do
        extract Mida::SchemaOrg::Person
        extract Mida::DataType::Text
      end

      # The telephone number.
      has_many 'telephone'

      # A contact location for a person's place of work.
      has_many 'workLocation' do
        extract Mida::SchemaOrg::Place
        extract Mida::SchemaOrg::ContactPoint
        extract Mida::DataType::Text
      end

      # Organizations that the person works for.
      has_many 'worksFor' do
        extract Mida::SchemaOrg::Organization
        extract Mida::DataType::Text
      end
    end

  end
end
