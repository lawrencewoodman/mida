$LOAD_PATH.unshift File.dirname(__FILE__)
Dir[File.dirname(__FILE__) + '/mida/*.rb'].each { |f| require f }

require 'mida_vocabulary/datatype'
require 'mida_vocabulary/propertydesc'

# Mida is a Microdata parser and extractor.
module Mida

end

require 'mida_vocabulary/vocabularies/genericvocabulary'
require 'mida_vocabulary/vocabularies/schemaorg'
