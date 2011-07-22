require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :WebPage, 'mida/vocabularies/schemaorg/webpage'

    # Web page type: Profile page.
    class ProfilePage < Mida::Vocabulary
      itemtype %r{http://schema.org/ProfilePage}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::CreativeWork
      include_vocabulary Mida::SchemaOrg::WebPage
    end

  end
end
