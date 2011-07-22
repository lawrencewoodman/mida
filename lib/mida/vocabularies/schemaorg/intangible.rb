require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'

    # A utility class that serves as the umbrella for a number of 'intangible' things such as quantities, structured values, etc.
    class Intangible < Mida::Vocabulary
      itemtype %r{http://schema.org/Intangible}i
      include_vocabulary Mida::SchemaOrg::Thing
    end

  end
end
