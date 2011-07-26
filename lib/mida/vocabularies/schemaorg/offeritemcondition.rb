require 'mida/datatype'

module Mida
  module SchemaOrg

    # A list of possible conditions for the item for sale.
    class OfferItemCondition < Mida::DataType::Enumeration
      VALID_VALUES = [
        [::Mida::DataType::URL, %r{http://schema.org/DamagedCondition}i],
        [::Mida::DataType::URL, %r{http://schema.org/NewCondition}i],
        [::Mida::DataType::URL, %r{http://schema.org/RefurbishedCondition}i],
        [::Mida::DataType::URL, %r{http://schema.org/UsedCondition}i]
      ]
    end

  end
end
