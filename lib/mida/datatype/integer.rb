module Mida
  module DataType

    # Integer data type
    module Integer

      # Returns the +value+ as an integer
      # Relies on +Integer+ to raise +ArgumentError+ if not valid
      def self.extract(value)
        Integer(value)
      end

    end
  end
end
