$LOAD_PATH.unshift File.dirname(__FILE__)
Dir[File.dirname(__FILE__) + '/mida/*.rb'].each { |f| require f }

# Mida is a Microdata parser and extractor.
module Mida
end
