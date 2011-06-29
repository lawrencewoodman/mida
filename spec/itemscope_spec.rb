require 'spec_helper'
require 'mida'

describe Mida::Itemscope, 'when initialized with an itemscope_node containing just itemprops' do
  before do
    html = <<-EOS
      <div itemprop="reviewer" itemscope>
        <span itemprop="first_name">Lorry </span>
        <span itemprop="last_name">Woodman</span>
      </div>
    EOS
    doc = Nokogiri(html).children.first
    @itemscope = Mida::Itemscope.new(doc)
  end

  it '#properties should return the correct name/value pairs' do
    @itemscope.properties.should == {
      'first_name' => ['Lorry'],
      'last_name' => ['Woodman']
    }
  end
end


describe Mida::Itemscope, 'when initialized with an itemscope_node not containing an itemtype' do
  before do
    html = <<-EOS
      <div itemprop="reviewer" itemscope>
        <span itemprop="first_name">Lorry </span>
        <span itemprop="last_name">Woodman</span>
      </div>
    EOS
    doc = Nokogiri(html).children.first
    @itemscope = Mida::Itemscope.new(doc)
  end

  it '#type should return nil' do
    @itemscope.type.should == nil
  end
end

describe Mida::Itemscope, 'when initialized with an itemscope_node containing an itemtype' do
  before do
    html = <<-EOS
      <div itemtype="person" itemprop="reviewer" itemscope>
        <span itemprop="first_name">Lorry </span>
        <span itemprop="last_name">Woodman</span>
      </div>
    EOS
    doc = Nokogiri(html).children.first
    @itemscope = Mida::Itemscope.new(doc)
  end

  it '#type should return nil' do
    @itemscope.type.should == "person"
  end
end

describe Mida::Itemscope, 'when initialized with an itemscope containing an itemprop with a relative url' do
  before do
    html = <<-EOS
      <div itemscope>
        <a itemprop="url" href="home/lorry">Lorry</a>
      </div>
    EOS
    @doc = Nokogiri(html).children.first
  end

  context 'and the page url is not passed' do
    before do
      @itemscope = Mida::Itemscope.new(@doc)
    end

    it 'should return the url as an absolute url' do
      @itemscope.properties['url'].should == ['']
    end
  end

  context 'and the page url is passed' do
    before do
      @itemscope = Mida::Itemscope.new(@doc, "http://example.com")
    end

    it 'should return the url as an absolute url' do
      @itemscope.properties['url'].should == ['http://example.com/home/lorry']
    end
  end

end

describe Mida::Itemscope, 'when initialized with an itemscope containing itemprops surrounded by a non microdata element' do
  before do
    html = <<-EOS
      <div itemprop="reviewer" itemtype="person" itemscope>
        <span itemprop="first_name">Lorry</span>
        <span><span itemprop="last_name">Woodman</span></span>
      </div>
    EOS
    doc = Nokogiri(html).children.first
    @itemscope = Mida::Itemscope.new(doc)
  end

  it '#properties should return the correct name/value pairs' do
    @itemscope.properties.should == {
      'first_name' => ['Lorry'],
      'last_name' => ['Woodman']
    }
  end

end

describe Mida::Itemscope, "when initialized with an itemscope containing itemprops
  who's inner text is surrounded by non-microdata elements" do
  before do
    html = <<-EOS
      <div itemscope>
        <span itemprop="reviewer">Lorry <em>Woodman</em></span>
      </div>'
    EOS
    doc = Nokogiri(html).children.first
    @itemscope = Mida::Itemscope.new(doc)
  end

  it '#properties should return the correct name/value pairs' do
    @itemscope.properties.should == {
      'reviewer' => ['Lorry Woodman']
    }
  end

end

describe Mida::Itemscope, "when initialized with an itemscope containing an itemprop
  nested within another itemprop" do
  before do
    html = <<-EOS
      <div itemscope>
        <span itemprop="description">The animal is a <span itemprop="colour">green</span> parrot.</span>
      </div>
    EOS
    doc = Nokogiri(html).children.first
    @itemscope = Mida::Itemscope.new(doc)
  end

  it '#properties should return both properties' do
    @itemscope.properties.should == {
      'description' => ['The animal is a green parrot.'],
      'colour' => ['green']
    }
  end

end

describe Mida::Itemscope, 'when initialized with an itemscope containing itemprops with the same name' do
  before do
    strawberry_html = <<-EOS
      <div itemprop="flavour" itemtype="icecream-type" itemscope>
        <span itemprop="fruit">Strawberry</span>
        <span itemprop="style">Homemade</span>
      </div>
    EOS
    html = html_wrap <<-EOS
      <div itemtype="icecreams" itemscope>
        <span itemprop="flavour">Lemon Sorbet</span>
        <span itemprop="flavour">Apricot Sorbet</span>
        #{strawberry_html}
      </div>
    EOS
    doc = Nokogiri(html).search('//*[@itemscope]').first
    strawberry_doc = Nokogiri(html_wrap(strawberry_html))
    strawberry_doc = strawberry_doc.search('//*[@itemscope]').first
    @itemscope = Mida::Itemscope.new(doc)
    @strawberry_itemscope = Mida::Itemscope.new(strawberry_doc)
  end

  it '#properties should return the correct name/value pairs' do
    @itemscope.properties.should == {
      'flavour' => [
        'Lemon Sorbet',
        'Apricot Sorbet',
        @strawberry_itemscope
      ]
    }
  end

end

describe Mida::Itemscope, 'when initialized with an itemscope containing itemrefs' do

  before do
    empty_band_html = <<-EOS
      <div id="b" itemprop="band" itemscope itemref="c">
      </div>
      <div id="c">
        <span itemprop="band_name">Jazz Band</span>
        <span itemprop="band_size">12</span>
      </div>
    EOS
    html = html_wrap <<-EOS
      <div itemscope itemref="a b">
        <span itemprop="age">30</span>
      </div>
      <div>
        <p id="a"><span itemprop="name">Amanda</span></p>
      </div>
      #{empty_band_html}
    EOS

    doc = Nokogiri(html).search('//*[@itemscope]').first
    empty_band_doc = Nokogiri(html_wrap(empty_band_html))
    empty_band_doc = empty_band_doc.search('//*[@itemscope]').first
    @itemscope = Mida::Itemscope.new(doc)
    @empty_band_itemscope = Mida::Itemscope.new(empty_band_doc)
  end

  it '#properties should return the correct name/value pairs' do
    @itemscope.properties.should == {
      'age' => ['30'],
      'name' => ['Amanda'],
      'band' => [@empty_band_itemscope]
    }
  end

end

describe Mida::Itemscope, 'when initialized with an itemscope containing an itemid' do

  before do
    html = html_wrap <<-EOS
      <div itemtype="book" itemscope itemid="urn:isbn:978-1-849510-50-9">
        <span itemprop="title">Hacking Vim 7.2</span>
        <span itemprop="author">Kim Schulz</span>
      </div>
    EOS

    doc = Nokogiri(html).search('//*[@itemscope]').first
    @itemscope = Mida::Itemscope.new(doc)
  end

  it '#id should return the correct id' do
    @itemscope.id.should == 'urn:isbn:978-1-849510-50-9'
  end

end

describe Mida::Itemscope, 'when initialized with an itemscope containing itemscopes as properties nested two deep' do
  before do
    reviewer_html = <<-EOS
      <div itemprop="reviewer" itemtype="person" itemscope>
        <span itemprop="first_name">Lorry</span>
        <span itemprop="last_name">Woodman</span>
        <div itemprop="represents" itemtype="organization" itemscope>
          <span itemprop="name">Acme</span>
        </div>
      </div>
    EOS
    html = html_wrap <<-EOS
      <div itemtype="review" itemscope>
        <span itemprop="item_name">Acme Anvil</span>
        <span itemprop="rating">5</span>
        #{reviewer_html}
      </div>
    EOS

    doc = Nokogiri(html).search('//*[@itemscope]').first
    reviewer_doc = Nokogiri(html_wrap(reviewer_html))
    reviewer_doc = reviewer_doc.search('//*[@itemscope]').first
    @itemscope = Mida::Itemscope.new(doc)
    @reviewer_itemscope = Mida::Itemscope.new(reviewer_doc)
  end

  it '#type should return the correct type' do
    @itemscope.type.should == 'review'
  end

  it '#id should return the correct id' do
    @itemscope.id.should == nil
  end

  it '#properties should return the correct name/value pairs' do
    @itemscope.properties.should == {
      'item_name' => ['Acme Anvil'],
      'rating' => ['5'],
      'reviewer' => [@reviewer_itemscope]
    }
  end

end
