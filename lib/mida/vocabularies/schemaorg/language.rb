require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'

    # Natural languages such as Spanish, Tamil, Hindi, English, etc. and programming languages such as Scheme and Lisp.
    class Language < Mida::Vocabulary
      itemtype %r{http://schema.org/Language}i
      include_vocabulary Mida::SchemaOrg::Thing
    end

  end
end
