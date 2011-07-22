require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'

    # An article, such as a news article or piece of investigative report. Newspapers and magazines have articles of many different types and this is intended to cover them all.
    class Article < Mida::Vocabulary
      itemtype %r{http://schema.org/Article}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::CreativeWork

      # The actual body of the article.
      has_many 'articleBody'

      # Articles may belong to one or more 'sections' in a magazine or newspaper, such as Sports, Lifestyle, etc.
      has_many 'articleSection'
    end

  end
end
