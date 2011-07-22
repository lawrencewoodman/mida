require 'mida/vocabulary'

module Mida
  module SchemaOrg


    # Quantity: Duration (use  ISO 8601 duration format).
    class Duration < Mida::Vocabulary
      itemtype %r{http://schema.org/Duration}i
    end

  end
end
