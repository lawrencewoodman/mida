module Mida
  # Module to hold the various data types
  # Each DataType should be a module containing class methods:
  # <tt>valid?</tt> and +extract+
  module DataType
  end
end

require_relative 'datatype/boolean'
require_relative 'datatype/float'
require_relative 'datatype/integer'
require_relative 'datatype/iso8601date'
require_relative 'datatype/number'
require_relative 'datatype/text'
