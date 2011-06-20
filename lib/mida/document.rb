require 'nokogiri'

module Mida

  # Class that holds the extracted Microdata
  class Document

    # An Array of Mida::Item objects.  These are all top-level
    # and hence not properties of other Items
    attr_reader :items

    # Create a new Microdata object
    #
    # [target] The string containing the html that you want to parse.
    # [page_url] The url of target used for form absolute urls. This must
    #            include the filename, e.g. index.html.
    def initialize(target, page_url=nil)
      @doc = Nokogiri(target)
      @page_url = page_url
      @items = extract_items
    end

    # Returns an array of matching Mida::Item objects
    #
    # [vocabulary] A regexp to match the item types against
    #              or a Class derived from Mida::VocabularyDesc
    #              to match against
    def search(vocabulary, items=@items)
      found_items = []
      regexp_passed = vocabulary.kind_of?(Regexp)
      regexp = if regexp_passed then vocabulary else vocabulary.itemtype end

      items.each do |item|
        # Allows matching against empty string, otherwise couldn't match
        # as item.type can be nil
        if (item.type.nil? && "" =~ regexp) || (item.type =~ regexp)
          found_items << item
        end
        found_items += search_values(item.properties.values, regexp)
      end
      found_items
    end

  private
    def extract_items
      itemscopes = @doc.search('//*[@itemscope and not(@itemprop)]')
      return nil unless itemscopes

      itemscopes.collect do |itemscope|
        itemscope = Itemscope.new(itemscope, @page_url)
        Item.new(itemscope)
      end
    end

    def search_values(values, vocabulary)
      items = []
      values.each do |value|
        if value.is_a?(Item) then items += search(vocabulary, [value])
        elsif value.is_a?(Array) then items += search_values(value, vocabulary)
        end
      end
      items
    end

  end

end
