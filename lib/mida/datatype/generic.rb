module Mida
  module DataType

    # The base DataType Parser
    class Generic
      
      # Convenience method, same as +new+
      def self.parse(value)
        self.new(value)
      end

      def method_missing(name, *args, &block)
        @parsedValue.send(name, *args, &block)
      end

      def to_s
        @parsedValue.to_s
      end

      def to_yaml(options={})
        to_s.to_yaml(options)
      end

      def ==(other)
        @parsedValue.to_s.downcase == other.to_s.downcase
      end

    end

  end
end
