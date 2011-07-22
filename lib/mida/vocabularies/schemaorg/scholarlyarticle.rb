require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :Article, 'mida/vocabularies/schemaorg/article'

    # A scholarly article.
    class ScholarlyArticle < Mida::Vocabulary
      itemtype %r{http://schema.org/ScholarlyArticle}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::CreativeWork
      include_vocabulary Mida::SchemaOrg::Article
    end

  end
end
