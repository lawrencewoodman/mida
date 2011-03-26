$LOAD_PATH.unshift File.dirname(__FILE__)
Dir[File.dirname(__FILE__) + '/mida/*.rb'].each { |f| require f }

# MiDa is a Microdata parser and extractor.
module MiDa
private
  def self.get_itemtype(itemscope)
    if (type = itemscope.attribute('itemtype')) then type.value else nil end
  end
end
