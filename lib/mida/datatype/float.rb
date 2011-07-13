require 'mida/datatype/generic'

module Mida
  module DataType

    # Float data type
    # Provides access to Float methods
    class Float < Generic

      # Raises +ArgumentError+ if value not valid
      def initialize(value)
        @parsedValue = ::Kernel.Float(value)
      end

    end

  end
end
