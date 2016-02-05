require 'mida/datatype/generic'
require 'date'

module Mida
  module DataType

    # ISO 8601 Date data type
    # Provides access to DateTime methods
    class ISO8601Date < Generic

      # Raises +ArgumentError+ if value not valid
      def initialize(value)
        @parsedValue = ::DateTime.iso8601(value)
      rescue => e
        raise ::ArgumentError, e
      end

      def to_s
        @parsedValue.rfc822
      end

    end

  end
end
