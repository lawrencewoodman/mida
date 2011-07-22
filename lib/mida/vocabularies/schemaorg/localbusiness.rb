require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Place, 'mida/vocabularies/schemaorg/place'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :Duration, 'mida/vocabularies/schemaorg/duration'

    # A particular physical business or branch of an organization. Examples of LocalBusiness include a restaurant, a particular branch of a restaurant chain, a branch of a bank, a medical practice, a club, a bowling alley, etc.
    class LocalBusiness < Mida::Vocabulary
      itemtype %r{http://schema.org/LocalBusiness}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Place
      include_vocabulary Mida::SchemaOrg::Organization

      # The larger organization that this local business is a branch of, if any.
      has_many 'branchOf' do
        extract Mida::SchemaOrg::Organization
        extract Mida::DataType::Text
      end

      # The currency accepted (in ISO 4217 currency format).
      has_many 'currenciesAccepted'

      # The opening hours for a business. Opening hours can be specified as a weekly time range, starting with days, then times per day. Multiple days can be listed with commas ',' separating each day. Day or time ranges are specified using a hyphen '-'.- Days are specified using the following two-letter combinations: Mo, Tu, We, Th, Fr, Sa, Su.- Times are specified using 24:00 time. For example, 3pm is specified as 15:00. - Here is an example: <time itemprop="openingHours" datetime="Tu,Th 16:00-20:00">Tuesdays and Thursdays 4-8pm</time>. - If a business is open 7 days a week, then it can be specified as <time itemprop="openingHours" datetime="Mo-Su">Monday through Sunday, all day</time>.
      has_many 'openingHours' do
        extract Mida::SchemaOrg::Duration
        extract Mida::DataType::Text
      end

      # Cash, credit card, etc.
      has_many 'paymentAccepted'

      # The price range of the business, for example $$$.
      has_many 'priceRange'
    end

  end
end
