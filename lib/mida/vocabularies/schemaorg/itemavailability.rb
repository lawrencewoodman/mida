require 'mida/datatype'

module Mida
  module SchemaOrg

    # A list of possible product availablity options.
    class ItemAvailability < Mida::DataType::Enumeration
      VALID_VALUES = [
        [::Mida::DataType::URL, %r{http://schema.org/Discontinued}i],
        [::Mida::DataType::URL, %r{http://schema.org/InStock}i],
        [::Mida::DataType::URL, %r{http://schema.org/InStoreOnly}i],
        [::Mida::DataType::URL, %r{http://schema.org/OnlineOnly}i],
        [::Mida::DataType::URL, %r{http://schema.org/OutOfStock}i],
        [::Mida::DataType::URL, %r{http://schema.org/PreOrder}i]
      ]
    end

  end
end
