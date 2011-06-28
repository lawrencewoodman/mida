require 'date'

module Mida
  module DataType

    # ISO 8601 Date data type
    module ISO8601Date
      # Returns whether a value is valid for this type
      def self.valid?(value)
        DateTime.iso8601(value) rescue nil
      end

      # Returns the +date+ as a +DateTime+ instance
      def self.extract(date)
        valid?(date)
      end
    end
  end
end
