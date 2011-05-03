require_relative 'spec_helper'
require_relative '../lib/mida'


describe Mida::Itemprop, 'when parsing an element without an itemprop attribute' do
  before do
    @element = mock_element('span')
  end

  it '#parse should return an empty Hash' do
    Mida::Itemprop.parse(@element).should == {}
  end
end

describe Mida::Itemprop, 'when parsing an element with one itemprop name' do
  before do
    @element = mock_element('span', {'itemprop' => 'reviewer'}, 'Lorry Woodman')
  end

  it '#parse should return a Hash with the correct name/value pair' do
    Mida::Itemprop.parse(@element).should == {'reviewer' => 'Lorry Woodman'}
  end
end

describe Mida::Itemprop, "when parsing an element who's inner text contains\
  non microdata elements" do
  before do
    html = '<span itemprop="reviewer">Lorry <em>Woodman</em></span>'
    doc = Nokogiri(html)
    @itemprop = doc.search('./*').first
  end

  it '#parse should return a Hash with the correct name/value pair' do
    Mida::Itemprop.parse(@itemprop).should == {'reviewer' => 'Lorry Woodman'}
  end
end

describe Mida::Itemprop, 'when parsing an itemscope element that has a relative url' do
  before do

    # The first_name element
    fn = mock_element('span', {'itemprop' => 'first_name'}, 'Lorry')

    # The last_name element
    ln = mock_element('span', {'itemprop' => 'last_name'}, 'Woodman')

    # The url.  This is important to check whether the page_url is passed onto Item
    url = mock_element('a', {'itemprop' => 'url', 'href' => 'home/LorryWoodman'})

    # The surrounding reviewer itemscope element
    @itemscope_el = mock_element('div', {'itemprop' => 'reviewer',
                                         'itemtype' => 'person',
                                         'itemscope' =>true}, nil, [fn,ln,url])
  end

  it '#parse should return a Hash with the correct name/value pair' do
    property = Mida::Itemprop.parse(@itemscope_el, "http://example.com")
    property.size.should == 1
    reviewer = property['reviewer']
    reviewer.type.should == 'person'
    reviewer.properties.should == {
      'first_name' => ['Lorry'],
      'last_name' => ['Woodman'],
      'url' => ['http://example.com/home/LorryWoodman']
    }
  end
end

describe Mida::Itemprop, 'when parsing an element with multiple itemprop names' do
  before do
    @element = mock_element('span', {'itemprop' => 'reviewer friend person'}, 'the property text')
  end

  it '#parse should return a Hash with the name/value pairs' do
    Mida::Itemprop.parse(@element).should == {
      'reviewer' => 'the property text',
      'friend' => 'the property text',
      'person' => 'the property text'
    }
  end
end

describe Mida::Itemprop, 'when parsing an element with non text content url values' do
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

  context 'when not given a page_url' do

    it 'should return nothing for relative urls' do
      url = 'register/index.html'
      URL_ELEMENTS.each do |tag, attr|
        element = mock_element(tag, {'itemprop' => 'url', attr => url})
        Mida::Itemprop.parse(element).should == {'url' => ''}
      end
    end

    it 'should return the url for absolute urls' do
      urls = [
        'http://example.com',
        'http://example.com/register',
        'http://example.com/register/index.html'
      ]

      urls.each do |url|
        URL_ELEMENTS.each do |tag, attr|
          element = mock_element(tag, {'itemprop' => 'url', attr => url})
          Mida::Itemprop.parse(element).should == {'url' => url}
        end
      end
    end
  end

  context 'when given a page_url' do
    before do
      @page_url = 'http://example.com/test/index.html'
    end

    it 'should return the absolute url for relative urls' do
      url = 'register/index.html'
      URL_ELEMENTS.each do |tag, attr|
        element = mock_element(tag, {'itemprop' => 'url', attr => url})
        Mida::Itemprop.parse(element, @page_url).should ==
          {'url' => 'http://example.com/test/register/index.html'}
      end
    end

    it 'should return the url unchanged for absolute urls' do
      urls = [
        'http://example.com',
        'http://example.com/register',
        'http://example.com/register/index.html'
      ]

      urls.each do |url|
        URL_ELEMENTS.each do |tag, attr|
          element = mock_element(tag, {'itemprop' => 'url', attr => url})
          Mida::Itemprop.parse(element, @page_url).should == {'url' => url}
        end
      end
    end

  end
end

describe Mida::Itemprop, 'when parsing an element with non text content non url values' do
  it 'should get values from a meta content attribute' do
    element = mock_element('meta', {'itemprop' => 'reviewer',
                                    'content' => 'Lorry Woodman'})
    Mida::Itemprop.parse(element).should == {'reviewer' => 'Lorry Woodman'}
  end

  it 'should get time from an time datatime attribute' do
    element = mock_element('time', {'itemprop' => 'dtreviewed',
                                    'datetime' => '2011-04-04'})
    Mida::Itemprop.parse(element).should == {'dtreviewed' => '2011-04-04'}
  end
end
