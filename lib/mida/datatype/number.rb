module Mida
  module DataType

    # Number data type
    # Provides access to Float methods
    class Number < Generic

      # Raises +ArgumentError+ if value not valid
      def initialize(value)
        @parsedValue = ::Kernel.Float(value)
      end

    end

  end
end
