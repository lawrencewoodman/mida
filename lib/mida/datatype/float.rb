module Mida
  module DataType

    # Float data type
    module Float
      # Returns whether a value is valid for this type
      def self.valid?(value)
        Float(value) rescue nil
      end

      # Returns the value as a floating point number
      def self.extract(value)
        valid?(value)
      end
    end
  end
end
