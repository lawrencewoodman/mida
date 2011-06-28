module Mida
  module DataType

    # Boolean data type
    module Boolean
      # Returns whether a value is valid for this type
      def self.valid?(value)
        ['true', 'false'].include?(value.downcase)
      end

      # Returns the value as a boolean
      def self.extract(value)
        value.downcase == 'true'
      end
    end
  end
end
