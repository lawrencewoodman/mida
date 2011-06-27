module Mida
  # Module to hold the various data types
  # Each DataType should be a module containing class methods:
  # <tt>valid?</tt> and +extract+
  module DataType
  end
end

require_relative 'datatype/text'
