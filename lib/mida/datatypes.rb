require 'nokogiri'
require 'uri'

module Mida

  # Module that handles the various data types
  module DataTypes

    TYPES = [:text]

    # Returns whether a value is valid for the type specified
    def self.valid?(type, value)
      case type
      when :text
        true
      else
        false
      end
    end

    # Returns the value extracted as the specified type
    def self.extract(type, value)
      case type
      when :text
        value
      else
        nil
      end
    end

  end

end
