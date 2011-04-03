require_relative 'spec_helper'
require_relative '../lib/mida'


describe MiDa::Property, 'when parsing an element without an itemprop attribute' do
  before do
    @element = mock(Nokogiri::XML::Element)
    @element.should_receive(:attribute).with('itemprop').and_return(nil)
  end

  it '#parse should return an empty Hash' do
    MiDa::Property.parse(@element).should == {}
  end
end

describe MiDa::Property, 'when parsing an element with one itemprop name' do
  before do
    itemprop_attr = mock(Nokogiri::XML::Attr)
    itemprop_attr.stub!(:value).and_return('reviewer')
    @element = mock(Nokogiri::XML::Element)
    @element.should_receive(:attribute).with('itemprop').and_return(itemprop_attr) 
    @element.should_receive(:attribute).with('itemscope').and_return(nil) 
    @element.stub!(:name).and_return('span')
    @element.stub!(:inner_text).and_return('the property text')
  end

  it '#parse should return a Hash with the correct name/value pair' do
    MiDa::Property.parse(@element).should == {'reviewer' => 'the property text'}
  end
end

describe MiDa::Property, 'when parsing an itemscope element' do
  before do

    # The first_name element
    first_attr = mock(Nokogiri::XML::Attr)
    first_attr.stub!(:value).and_return('first_name')
    fn = mock(Nokogiri::XML::Element)
    fn.should_receive(:attribute).with('itemprop').and_return(first_attr)
    fn.should_receive(:attribute).with('itemscope').and_return(nil)
    fn.stub!(:name).and_return('span')
    fn.stub!(:inner_text).and_return('Lorry')
    fn.stub!(:search).with('./*').and_return([])

    # The last_name element
    last_attr = mock(Nokogiri::XML::Attr)
    last_attr.stub!(:value).and_return('last_name')
    ln = mock(Nokogiri::XML::Element)
    ln.should_receive(:attribute).with('itemprop').and_return(last_attr)
    ln.should_receive(:attribute).with('itemscope').and_return(nil)
    ln.stub!(:name).and_return('span')
    ln.stub!(:inner_text).and_return('Woodman')
    ln.stub!(:search).with('./*').and_return([])

    # The surrounding reviewer itemscope element
    itemprop_attr = mock(Nokogiri::XML::Attr)
    itemprop_attr.stub!(:value).and_return('reviewer')
    itemscope_attr = mock(Nokogiri::XML::Attr)
    itemtype_attr = mock(Nokogiri::XML::Attr)
    itemtype_attr.stub!(:value).and_return(nil)
    @element = mock(Nokogiri::XML::Element)
    @element.should_receive(:attribute).with('itemprop').and_return(itemprop_attr)
    @element.should_receive(:attribute).with('itemscope').and_return(itemscope_attr)
    @element.should_receive(:attribute).with('itemtype').and_return(itemtype_attr)
    @element.stub!(:name).and_return('span')
    @element.stub!(:search).with('./*').and_return([fn,ln])
  end

  it '#parse should return a Hash with the correct name/value pair' do
    property = MiDa::Property.parse(@element)
    property.size.should == 1
    reviewer = property['reviewer']
    reviewer.type.should == nil
    reviewer.properties.should == {'first_name' => 'Lorry', 'last_name' => 'Woodman'}
  end
end

describe MiDa::Property, 'when parsing an element with multiple itemprop names' do
  before do
    itemprop_attr = mock(Nokogiri::XML::Attr)
    itemprop_attr.stub!(:value).and_return('reviewer friend person')
    @element = mock(Nokogiri::XML::Element)
    @element.should_receive(:attribute).with('itemprop').and_return(itemprop_attr) 
    @element.should_receive(:attribute).any_number_of_times.with('itemscope').and_return(nil) 
    @element.stub!(:name).and_return('span')
    @element.stub!(:inner_text).and_return('the property text')
  end

  it '#parse should return a Hash with the name/value pairs' do
    MiDa::Property.parse(@element).should == {
      'reviewer' => 'the property text',
      'friend' => 'the property text',
      'person' => 'the property text'
    }
  end
end

describe MiDa::Property, 'when parsing an element with non text content url values' do
  before :all do
    URL_ELEMENTS = {
      'a' => 'href',     'area' => 'href',
      'audio' => 'src',  'embed' => 'src',
      'iframe' => 'src', 'img' => 'src',
      'link' => 'href',  'source' => 'src',
      'object' => 'data', 'track' => 'src',
      'video' => 'src'
    }
  end

  before :each do

    itemprop_attr = mock(Nokogiri::XML::Attr)
    itemprop_attr.stub!(:value).and_return('url')
    @element = mock(Nokogiri::XML::Element)
    @element.should_receive(:attribute).any_number_of_times.with('itemprop').and_return(itemprop_attr)
    @element.should_receive(:attribute).any_number_of_times.with('itemscope').and_return(nil)
  end

  context 'when not given a page_url' do
    before do
      @url_attr = mock(Nokogiri::XML::Attr)
    end

    it 'should return nothing for relative urls' do
      @url_attr.stub!(:value).and_return('register/index.html')
      URL_ELEMENTS.each do |tag, attr|
        @element.stub!(:name).and_return(tag)
        @element.should_receive(:attribute).with(attr).and_return(@url_attr)
        MiDa::Property.parse(@element).should == {'url' => ''}
      end
    end

    it 'should return the url for absolute urls' do
      urls = [
        'http://example.com',
        'http://example.com/register',
        'http://example.com/register/index.html'
      ]

      urls.each do |url|
        @url_attr.stub!(:value).and_return(url)
        URL_ELEMENTS.each do |tag, attr|
          @element.stub!(:name).and_return(tag)
          @element.should_receive(:attribute).with(attr).and_return(@url_attr)
          MiDa::Property.parse(@element).should == {'url' => url}
        end
      end
    end
  end

  context 'when given a page_url' do
    before do
      @url_attr = mock(Nokogiri::XML::Attr)
      @page_url = 'http://example.com/test/index.html'
    end

    it 'should return the absolute url for relative urls' do
      @url_attr.stub!(:value).and_return('register/index.html')
      URL_ELEMENTS.each do |tag, attr|
        @element.stub!(:name).and_return(tag)
        @element.should_receive(:attribute).with(attr).and_return(@url_attr)
        MiDa::Property.parse(@element, @page_url).should == {'url' => 'http://example.com/test/register/index.html'}
      end
    end

    it 'should return the url unchanged for absolute urls' do
      urls = [
        'http://example.com',
        'http://example.com/register',
        'http://example.com/register/index.html'
      ]

      urls.each do |url|
        @url_attr.stub!(:value).and_return(url)
        URL_ELEMENTS.each do |tag, attr|
          @element.stub!(:name).and_return(tag)
          @element.should_receive(:attribute).with(attr).and_return(@url_attr)
          MiDa::Property.parse(@element, @page_url).should == {'url' => url}
        end
      end
    end

  end
end

describe MiDa::Property, 'when parsing an element with non text content non url values' do
  before do
    @itemprop_attr = mock(Nokogiri::XML::Attr)
    @element = mock(Nokogiri::XML::Element)
    @element.should_receive(:attribute).any_number_of_times.with('itemprop').and_return(@itemprop_attr)
    @element.should_receive(:attribute).any_number_of_times.with('itemscope').and_return(nil)
  end

  it 'should get values from a meta content attribute' do
    @itemprop_attr.stub!(:value).and_return('reviewer')
    reviewer_attr = mock(Nokogiri::XML::Attr)
    reviewer_attr.stub!(:value).and_return('Lorry Woodman')
    @element.stub!(:name).and_return('meta')
    @element.should_receive(:attribute).with('content').and_return(reviewer_attr)
    MiDa::Property.parse(@element).should == {'reviewer' => 'Lorry Woodman'}
  end

  it 'should get time from an time datatime attribute' do
    @itemprop_attr.stub!(:value).and_return('dtreviewed')
    date_attr = mock(Nokogiri::XML::Attr)
    date_attr.stub!(:value).and_return('2011-04-04')
    @element.stub!(:name).and_return('time')
    @element.should_receive(:attribute).with('datetime').and_return(date_attr)
    MiDa::Property.parse(@element).should == {'dtreviewed' => '2011-04-04'}
  end
end
