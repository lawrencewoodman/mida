require "mida/version"
Dir[File.dirname(__FILE__) + '/mida/*.rb'].each { |f| require f }

# Mida is a Microdata parser and extractor.
module Mida

end

require 'mida/vocabularies/genericvocabulary'
require 'mida/vocabularies/schemaorg'
