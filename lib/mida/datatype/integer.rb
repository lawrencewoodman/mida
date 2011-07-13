module Mida
  module DataType

    # Integer data type
    # Provides access to Integer methods
    class Integer < Generic

      # Raises +ArgumentError+ if value not valid
      def initialize(value)
        @parsedValue = ::Kernel.Integer(value)
      end

    end
  end
end
