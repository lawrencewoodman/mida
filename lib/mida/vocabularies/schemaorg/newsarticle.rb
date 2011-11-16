require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :CreativeWork, 'mida/vocabularies/schemaorg/creativework'
    autoload :Article, 'mida/vocabularies/schemaorg/article'

    # A news article
    class NewsArticle < Mida::Vocabulary
      itemtype %r{http://schema.org/NewsArticle}i
      include_vocabulary Mida::SchemaOrg::Thing
      include_vocabulary Mida::SchemaOrg::CreativeWork
      include_vocabulary Mida::SchemaOrg::Article

      # The location where the NewsArticle was produced.
      has_many 'dateline'

      # The number of the column in which the NewsArticle appears in the print edition.
      has_many 'printColumn'

      # The edition of the print product in which the NewsArticle appears.
      has_many 'printEdition'

      # If this NewsArticle appears in print, this field indicates the name of the page on which the article is found. Please note that this field is intended for the exact page name (e.g. A5, B18).
      has_many 'printPage'

      # If this NewsArticle appears in print, this field indicates the print section in which the article appeared.
      has_many 'printSection'
    end

  end
end
