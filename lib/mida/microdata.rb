require 'nokogiri'
require 'uri'

# MiDa is a Microdata parser and extractor.
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

    NON_TEXTCONTENT_ELEMENTS = {
      'a' => 'href',        'area' => 'href',
      'audio' => 'src',     'embed' => 'src',
      'iframe' => 'src',    'img' => 'src',
      'link' => 'href',     'meta' => 'content',
      'object' => 'data',   'source' => 'src',
      'time' => 'datetime', 'track' => 'src',
      'video' => 'src'
    }

    URL_ATTRIBUTES = ['data', 'href', 'src']

    def get_itemtype(itemscope)
      if (type = itemscope.attribute('itemtype')) then type.value else nil end
    end

    def get_itemscopes(doc)
      itemscopes_doc = doc.search('//*[@itemscope and not(@itemprop)]')
      return nil if itemscopes_doc.nil?

      itemscopes_doc.collect do |itemscope_doc|
        Hash[:type, get_itemtype(itemscope_doc),
             :properties, get_properties(itemscope_doc)
        ]
      end
    end

    def get_itemprops(itemscope)
      tags = itemscope.search('./*')
      itemprops = []

      tags.each do |tag|
        if tag.attribute('itemprop').nil?
          itemprops += get_itemprops(tag)
        else
          itemprops << tag
        end
      end

      itemprops
    end

    # This returns an empty string if can't form a valid
    # absolute url as per the Microdata spec.
    def make_absolute_url(url)
      return url unless URI.parse(url).relative?
      begin
        URI.parse(@page_url).merge(url).to_s
      rescue URI::Error
        ''
      end
    end

    def get_property_value(itemprop)
      element = itemprop.name
      if NON_TEXTCONTENT_ELEMENTS.has_key?(element)
        attribute = NON_TEXTCONTENT_ELEMENTS[element]
        value = itemprop.attribute(attribute).value
        (URL_ATTRIBUTES.include?(attribute)) ? make_absolute_url(value) : value
      else
        itemprop.inner_text
      end
    end

    def get_property(itemprop)
      if itemprop.attribute('itemscope').nil?
        get_property_value(itemprop)
      else
        Hash[:type, get_itemtype(itemprop),
             :properties, get_properties(itemprop)
        ]
      end
    end

    def update_property(current_property, itemprop)
      new_property = get_property(itemprop)
      if current_property.is_a?(Array)
        current_property << new_property
      else
        current_property = [current_property, new_property]
      end
    end

    def get_properties(itemscope)
      itemprops = get_itemprops(itemscope)
      return nil if itemprops.nil?
      properties = {}

      itemprops.each do |itemprop|
        itemprop.attribute('itemprop').value.split().each do |property|
          properties[property] =
          if properties.has_key?(property)
            update_property(properties[property], itemprop)
          else
            get_property(itemprop)
          end
        end
      end

      (properties.empty?) ? nil : properties
    end

    def filter_vocabularies(itemscopes, vocabulary)
      itemscope_vocabs = []

      itemscopes.each do |itemscope|
        if itemscope[:type] == vocabulary
          itemscope_vocabs << itemscope
        end

        itemscope[:properties].each do |property|
          if (value = property[1]).is_a?(Hash)
            itemscope_vocabs += filter_vocabularies([value], vocabulary)
          elsif value.is_a?(Array)
            value.each do |v|
              if v.is_a?(Hash)
                itemscope_vocabs += filter_vocabularies([v], vocabulary)
              end
            end
          end
        end
      end

      itemscope_vocabs
    end

  end
end
