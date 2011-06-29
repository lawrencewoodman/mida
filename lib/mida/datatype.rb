module Mida
  # Module to hold the various data types.
  # Each DataType should be a module containing the class method: +extract+
  # which returns the value extracted or raises an +ArgumentError+ exception
  # if input value is not valid.
  module DataType
  end
end

require 'mida/datatype/boolean'
require 'mida/datatype/float'
require 'mida/datatype/integer'
require 'mida/datatype/iso8601date'
require 'mida/datatype/number'
require 'mida/datatype/text'
