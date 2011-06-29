module Mida
  module DataType

    # Number data type
    module Number

      # Returns the +value+ as a number
      # Relies on +Float+ to raise +ArgumentError+ if not valid
      def self.extract(value)
        Float(value)
      end

    end
  end
end
