require 'date'

module Mida
  module DataType

    # URL data type
    module URL
      # Returns the +value+ as a +URI+ instance
      # Raises +ArgumentError+ if value not valid url
      def self.extract(value)
        raise ArgumentError unless value =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]
        URI.parse(value)
      end
    end
  end
end
