module Mida
  module DataType

    # Text data type
    class Text < Generic

      # Returns the value extracted
      def initialize(value)
        @parsedValue = value
      end

    end

  end
end
