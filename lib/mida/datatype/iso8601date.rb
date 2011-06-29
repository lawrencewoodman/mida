require 'date'

module Mida
  module DataType

    # ISO 8601 Date data type
    module ISO8601Date

      # Returns the +value+ as a +DateTime+ instance
      # Relies on <tt>DateTime#iso8601</tt> to raise
      # +ArgumentError+ if not valid
      def self.extract(value)
        DateTime.iso8601(value)
      end
    end
  end
end
