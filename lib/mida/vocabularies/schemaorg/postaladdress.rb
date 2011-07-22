require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :ContactPoint, 'mida/vocabularies/schemaorg/contactpoint'
    autoload :Country, 'mida/vocabularies/schemaorg/country'

    # The mailing address.
    class PostalAddress < Mida::Vocabulary
      itemtype %r{http://schema.org/PostalAddress}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::ContactPoint

      # The country. For example, USA. You can also provide the two-letter ISO 3166-1 alpha-2 country code.
      has_many 'addressCountry' do
        extract Mida::SchemaOrg::Country
        extract Mida::DataType::Text
      end

      # The locality. For example, Mountain View.
      has_many 'addressLocality'

      # The region. For example, CA.
      has_many 'addressRegion'

      # The post offce box number for PO box addresses.
      has_many 'postOfficeBoxNumber'

      # The postal code. For example, 94043.
      has_many 'postalCode'

      # The street address. For example, 1600 Amphitheatre Pkwy.
      has_many 'streetAddress'
    end

  end
end
