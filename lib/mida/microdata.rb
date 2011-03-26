require 'nokogiri'

module MiDa

  # Class that holds the extracted Microdata
  class Microdata

    # Create a new Microdata object
    #
    # [target] The string containing the html that you want to parse
    # [page_url] The url of target used for form absolute urls
    def initialize(target, page_url=nil)
      @doc = Nokogiri(target)
      @page_url = page_url
      @itemscopes = get_itemscopes(@doc)
    end

    # Returns the found vocabularies/itemscopes as an array of hashes
    #
    # [vocabulary] If passed restricts the vocabularies to only ones that match
    #              or are being used as a property of one that matches
    def find(vocabulary=nil)
      itemscopes = vocabulary.nil? ? @itemscopes : filter_vocabularies(@itemscopes, vocabulary)
      itemscopes.empty? ? nil : itemscopes
    end

  private
    def get_itemscopes(doc)
      itemscopes_doc = doc.search('//*[@itemscope and not(@itemprop)]')
      return nil unless itemscopes_doc

      itemscopes_doc.collect do |itemscope_doc|
        Item.new(itemscope_doc, @page_url)
      end
    end

    def filter_vocabularies(vocabularies, vocabulary_filter)
      return_vocabs = []

      vocabularies.each do |vocabulary|
        if vocabulary.type == vocabulary_filter
          return_vocabs << vocabulary
        end

        vocabulary.properties.each do |property, value|
          if value.is_a?(MiDa::Item)
            return_vocabs += filter_vocabularies([value], vocabulary_filter)
          elsif value.is_a?(Array)
            value.each do |element|
              if element.is_a?(MiDa::Item)
                return_vocabs += filter_vocabularies([element], vocabulary_filter)
              end
            end
          end
        end
      end

      return_vocabs
    end

  end

end
