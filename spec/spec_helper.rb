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
def mock_element(tag, attributes={}, inner_text=nil, search_return=[])
  element = mock(Nokogiri::XML::Element)

  ['itemtype', 'itemscope', 'itemprop'].each do |name|
    attributes[name] = nil unless attributes.has_key?(name)
  end
  attributes.each do |name, value|
    element_add_attribute(element, name, value)
  end
  element.stub!(:inner_text).and_return(inner_text)

  element.stub!(:name).and_return(tag)
  element.stub!(:search).with('./*').and_return(search_return)
  element
end
