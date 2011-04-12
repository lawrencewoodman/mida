require 'rspec'

def element_add_attribute(element, attribute, value)
  if value
    attr = mock(Nokogiri::XML::Attr)
    if value != true
      attr.stub!(:value).and_return(value)
    end
  end
  element.should_receive(:attribute).any_number_of_times.with(attribute).and_return(attr)
  element
end

# Return a mock Nokogiri::XML::Element
def mock_element(tag, attributes={}, inner_text=nil, search_return=[], id_searches={})
  element = mock(Nokogiri::XML::Element)

  ['id', 'itemid', 'itemprop', 'itemref', 'itemscope', 'itemtype'].each do |name|
    attributes[name] = nil unless attributes.has_key?(name)
  end
  attributes.each do |name, value|
    element_add_attribute(element, name, value)
  end

  element.stub!(:inner_text).and_return(inner_text)
  element.stub!(:name).and_return(tag)

  element.should_receive(:search).any_number_of_times.with('./*').and_return(search_return)

  # Set a valid return element for each likely id
  ('a'..'z').each do |id|
    stub = element.should_receive(:search).any_number_of_times.with("//*[@id='#{id}']")
    if id_searches.has_key?(id)
      stub.and_return([id_searches[id]])
    else
      stub.and_return([])
    end
  end

  element
end
