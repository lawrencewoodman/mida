module Mida
  module DataType

    # Text data type
    module Text
      # Returns whether a value is valid for this type
      def self.valid?(value)
        !value.nil?
      end

      # Returns the value extracted
      def self.extract(value)
        value
      end
    end
  end
end
