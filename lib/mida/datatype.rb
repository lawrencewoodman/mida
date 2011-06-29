module Mida
  # Module to hold the various data types
  # Each DataType should be a module containing class methods:
  # <tt>valid?</tt> and +extract+
  module DataType
  end
end

require 'mida/datatype/boolean'
require 'mida/datatype/float'
require 'mida/datatype/integer'
require 'mida/datatype/iso8601date'
require 'mida/datatype/number'
require 'mida/datatype/text'
