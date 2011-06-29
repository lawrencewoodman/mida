module Mida
  module DataType

    # Boolean data type
    module Boolean

      # Returns the +value+ as a boolean
      # or raises ArgumentError if not valid
      def self.extract(value)
        case value.downcase
        when 'true' then true
        when 'false' then false
        else raise ArgumentError, 'Invalid value'
        end
      end
    end
  end
end
