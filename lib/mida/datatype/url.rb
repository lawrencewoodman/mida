require 'mida/datatype/generic'
require 'uri'

module Mida
  module DataType

    # URL data type
    # Provides access to URI methods
    class URL < Generic

      # Raises +ArgumentError+ if value not valid url
      def initialize(value)
        raise ::ArgumentError unless value =~ ::URI::DEFAULT_PARSER.regexp[:ABS_URI]
        @parsedValue = ::URI.parse(value)
      end

    end

  end
end
