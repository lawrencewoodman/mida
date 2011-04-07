require 'nokogiri'

module MiDa

  # Class that holds the extracted Microdata
  class Microdata

    # An Array of MiDa::Item objects.  These are all top-level
    # and hence not properties of other Items
    attr_reader :items

    # Create a new Microdata object
    #
    # [target] The string containing the html that you want to parse
    # [page_url] The url of target used for form absolute urls. This must
    #            include the filename, e.g. index.html.
    def initialize(target, page_url=nil)
      @doc = Nokogiri(target)
      @page_url = page_url
      @items = get_items(@doc)
    end

    # Returns an array of matching MiDa::Item objects
    #
    # [vocabulary] A regexp to match the item types against
    def search(vocabulary, items=@items)
      found_items = []
      items.each do |item|
        # Allows matching against empty string, otherwise couldn't match
        # as item.type can be nil
        if (item.type.nil? && "" =~ vocabulary) || (item.type =~ vocabulary)
          found_items << item
        end
        found_items += search_values(item.properties.values, vocabulary)
      end
      found_items
    end

  private
    def get_items(doc)
      items_doc = doc.search('//*[@itemscope and not(@itemprop)]')
      return nil unless items_doc

      items_doc.collect do |item_doc|
        Item.new(item_doc, @page_url)
      end
    end

    def search_values(values, vocabulary)
      items = []
      values.each do |value|
        if value.is_a?(MiDa::Item) then items += search(vocabulary, [value])
        elsif value.is_a?(Array) then items += search_values(value, vocabulary)
        end
      end
      items
    end

  end

end
