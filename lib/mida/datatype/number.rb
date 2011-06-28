module Mida
  module DataType

    # Number data type
    module Number
      # Returns whether a value is valid for this type
      def self.valid?(value)
        Float(value) rescue nil
      end

      # Returns the value as a number
      def self.extract(value)
        valid?(value)
      end
    end
  end
end
