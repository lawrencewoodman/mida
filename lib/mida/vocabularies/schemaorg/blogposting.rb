require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :Article, 'mida/vocabularies/schemaorg/article'

    # A blog post.
    class BlogPosting < Mida::Vocabulary
      itemtype %r{http://schema.org/BlogPosting}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::CreativeWork
      include_vocabulary Mida::SchemaOrg::Article
    end

  end
end
