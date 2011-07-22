require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Place, 'mida/vocabularies/schemaorg/place'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :LocalBusiness, 'mida/vocabularies/schemaorg/localbusiness'

    # A food-related business.
    class FoodEstablishment < Mida::Vocabulary
      itemtype %r{http://schema.org/FoodEstablishment}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Place
      include_vocabulary Mida::SchemaOrg::Organization
      include_vocabulary Mida::SchemaOrg::LocalBusiness

      # Either Yes/No, or a URL at which reservations can be made.
      has_many 'acceptsReservations' do
        extract Mida::DataType::URL
        extract Mida::DataType::Text
      end

      # Either the actual menu or a URL of the menu.
      has_many 'menu' do
        extract Mida::DataType::URL
        extract Mida::DataType::Text
      end

      # The cuisine of the restaurant.
      has_many 'servesCuisine'
    end

  end
end
