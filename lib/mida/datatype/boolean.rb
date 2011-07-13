require 'mida/datatype/generic'

module Mida
  module DataType

    # Boolean data type
    # Provides access to TrueClass/FalseClass methods
    class Boolean < Generic

      # Raises +ArgumentError+ if value not valid boolean
      def initialize(value)
        @parsedValue = case value.downcase
                       when 'true' then true
                       when 'false' then false
                       else raise ::ArgumentError, 'Invalid value'
                       end
      end

      def to_s
        @parsedValue.to_s.capitalize
      end

      def !@
        !@parsedValue
      end

    end

  end
end
