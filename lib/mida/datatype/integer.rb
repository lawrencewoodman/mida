module Mida
  module DataType

    # Integer data type
    module Integer
      # Returns whether a value is valid for this type
      def self.valid?(value)
        Integer(value) rescue nil
      end

      # Returns the value as an integer
      def self.extract(value)
        valid?(value)
      end
    end
  end
end
