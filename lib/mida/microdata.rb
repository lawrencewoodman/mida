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
      @items = get_items(@doc)
    end

    # Returns the matching items an array of MiDa::Item objects
    #
    # [vocabulary] If passed, restricts the items to only ones that match
    #              or are being used as a property of one that matches
    def find(vocabulary=nil)
      vocabulary.nil? ? @items : filter_vocabularies(@items, vocabulary)
    end

  private
    def get_items(doc)
      items_doc = doc.search('//*[@itemscope and not(@itemprop)]')
      return nil unless items_doc

      items_doc.collect do |item_doc|
        Item.new(item_doc, @page_url)
      end
    end

    def filter_vocabularies(items, vocabulary_filter)
      return_vocabs = []

      items.each do |item|
        if item.type == vocabulary_filter
          return_vocabs << item
        end

        item.properties.each do |name, value|
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
