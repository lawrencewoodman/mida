require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Event, 'mida/vocabularies/schemaorg/event'

    # Event type: Social event.
    class SocialEvent < Mida::Vocabulary
      itemtype %r{http://schema.org/SocialEvent}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::Event
    end

  end
end
