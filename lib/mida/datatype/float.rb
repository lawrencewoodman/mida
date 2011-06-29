module Mida
  module DataType

    # Float data type
    module Float

      # Returns the +value+ as a floating point number
      # Relies on +Float+ to raise +ArgumentError+ if not valid
      def self.extract(value)
        Float(value)
      end

    end
  end
end
