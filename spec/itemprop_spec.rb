require 'spec_helper'
require 'mida/itemprop'


describe Mida::Itemprop, 'when parsing an element without an itemprop attribute' do
  before do
    html = '<span>Lorry</span>'
    @element = Nokogiri(html).children.first
  end

  it '#parse should return an empty Hash' do
    Mida::Itemprop.parse(@element).should == {}
  end
end

describe Mida::Itemprop, 'when parsing an element with one itemprop name' do
  before do
    html = '<span itemprop="reviewer">Lorry Woodman</span>'
    @element = Nokogiri(html).children.first
  end

  it '#parse should return a Hash with the correct name/value pair' do
    Mida::Itemprop.parse(@element).should == {'reviewer' => 'Lorry Woodman'}
  end
end

describe Mida::Itemprop, "when parsing an element who's inner text contains\
  non microdata elements" do
  before do
    html = '<span itemprop="reviewer">Lorry <em>Woodman</em></span>'
    @itemprop = Nokogiri(html).children.first
  end

  it '#parse should return a Hash with the correct name/value pair' do
    Mida::Itemprop.parse(@itemprop).should == {'reviewer' => 'Lorry Woodman'}
  end
end

describe Mida::Itemprop, 'when parsing an itemscope element that has a relative url' do
  before do
    html = html_wrap <<-EOS
      <div itemprop="reviewer" itemtype="person" itemscope>
        <a itemprop="url" href="home/LorryWoodman">
        </a>
      </div>
    EOS

    itemprop = Nokogiri(html).search('//*[@itemscope]')
    @properties = Mida::Itemprop.parse(itemprop, "http://example.com")
  end

  it 'should create an absolute url' do
    url = @properties['reviewer'].properties['url']
    url.should == ['http://example.com/home/LorryWoodman']
  end
end

describe Mida::Itemprop, 'when parsing an element with multiple itemprop names' do
  before do
    html = '<span itemprop="reviewer friend person">some text</span>'
    itemprop = Nokogiri(html).children.first
    @properties = Mida::Itemprop.parse(itemprop)
  end

  it 'it should return a Hash with the each of the itemprop names as keys' do
    @properties.should == {
      'reviewer' => 'some text',
      'friend' => 'some text',
      'person' => 'some text'
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
        html = html_wrap %Q{<#{tag} itemprop="url" #{attr}="#{url}">The url</#{tag}>}
        element = Nokogiri(html).search('//*[@itemprop]').first
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
          html = html_wrap %Q{<#{tag} itemprop="url" #{attr}="#{url}">The url</#{tag}>}
          element = Nokogiri(html).search('//*[@itemprop]').first
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
        html = html_wrap %Q{<#{tag} itemprop="url" #{attr}="#{url}">The url</#{tag}>}
        element = Nokogiri(html).search('//*[@itemprop]').first
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
          html = html_wrap %Q{<#{tag} itemprop="url" #{attr}="#{url}">The url</#{tag}>}
          element = Nokogiri(html).search('//*[@itemprop]').first
          Mida::Itemprop.parse(element, @page_url).should == {'url' => url}
        end
      end
    end

  end
end

describe Mida::Itemprop, 'when parsing an element with non text content non url values' do
  it 'should get values from a meta content attribute' do
    html = html_wrap %q{<meta itemprop="reviewer" content="Lorry Woodman"/>}
    element = Nokogiri(html).search('//*[@itemprop]').first
    Mida::Itemprop.parse(element).should == {'reviewer' => 'Lorry Woodman'}
  end

  it 'should get time from an time datatime attribute' do
    html = html_wrap %q{<time itemprop="dtreviewed" datetime="2011-05-04"/>}
    element = Nokogiri(html).search('//*[@itemprop]').first
    Mida::Itemprop.parse(element).should == {'dtreviewed' => '2011-05-04'}
  end
end

describe Mida::Itemprop, '#make_absolute_url' do
  it "should parse url with white spaces" do
    class ItempropTastCase < Mida::Itemprop
      def initialize(*args)
        #nothing
      end
    end
    
    url = "http://www.imamuseum.org/sites/default/files/imagecache/3_column/product-images/slvr mesh earrings.jpg"
    
    ItempropTastCase.new.send(:make_absolute_url, url).should == URI.escape(url)
  end
end