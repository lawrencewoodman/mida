require 'nokogiri'

module Mida

  # Class that holds the extracted Microdata
  class Document
    include Enumerable

    # An Array of Mida::Item objects.  These are all top-level
    # and hence not properties of other Items
    attr_reader :items

    # Create a new Microdata object
    #
    # [target] The string containing the html that you want to parse.
    # [page_url] The url of target used for form absolute urls. This must
    #            include the filename, e.g. index.html.
    # [validate] Whether to validate the items against known vocabularies.
    def initialize(target, page_url=nil, validate=true)
      @doc = Nokogiri(target)
      @page_url = page_url
      @items = extract_items(validate)
    end

    # Implements method for Enumerable
    def each
      @items.each {|item| yield(item)}
    end

    # Returns an array of matching <tt>Mida::Item</tt> objects
    #
    # This drills down through each +Item+ to find match items
    #
    # [itemtype] A regexp to match the item types against
    # [items]    An array of items to search.  If no argument supplied, will
    #            search through all items in the document.
    def search(itemtype, items=@items)
      items.each_with_object([]) do |item, found_items|
        # Allows matching against empty string, otherwise couldn't match
        # as item.type can be nil
        if (item.type.nil? && "" =~ itemtype) || (item.type =~ itemtype)
          found_items << item
        end
        found_items.concat(search_values(item.properties.values, itemtype))
      end
    end

  private
    def extract_items(validate)
      itemscopes = @doc.search('//*[@itemscope and not(@itemprop)]')
      return nil unless itemscopes

      itemscopes.collect do |itemscope|
        itemscope = Itemscope.new(itemscope, @page_url)
        Item.new(itemscope, validate)
      end
    end

    def search_values(values, vocabulary)
      values.each_with_object([]) do |value, items|
        if value.is_a?(Item) then items.concat(search(vocabulary, [value]))
        elsif value.is_a?(Array) then items.concat(search_values(value, vocabulary))
        end
      end
    end

  end

end
