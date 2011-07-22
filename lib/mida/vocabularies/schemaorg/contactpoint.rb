require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'

    # A contact point - for example, a Customer Complaints department.
    class ContactPoint < Mida::Vocabulary
      itemtype %r{http://schema.org/ContactPoint}i
      include_vocabulary Mida::SchemaOrg::Thing

      # A person or organization can have different contact points, for different purposes. For example, a sales contact point, a PR contact point and so on. This property is used to specify the kind of contact point.
      has_many 'contactType'

      # Email address.
      has_many 'email'

      # The fax number.
      has_many 'faxNumber'

      # The telephone number.
      has_many 'telephone'
    end

  end
end
