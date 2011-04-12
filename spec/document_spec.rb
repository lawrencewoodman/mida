require_relative 'spec_helper'
require_relative '../lib/mida'

def test_parsing(md, vocabulary, expected_results)
  items = md.search(vocabulary)
  expected_results.each_with_index do |expected_result,i|
    item = items[i]
    test_to_h(item, expected_result)
    test_properties(item, expected_result)
  end
end

def test_to_h(item, expected_result)
  item.to_h.should == expected_result
end

def test_properties(item, expected_result)
  item.properties.each do |name, value|
    match_array(value, expected_result[:properties][name])
  end
end

def match_array(value_array, expected_results)
  value_array.each_with_index do |element, i|
    if element.is_a?(Mida::Item)
      test_properties(element, expected_results[i])
    else
      element.should == expected_results[i]
    end
  end
end

shared_examples_for 'one root itemscope' do
  it 'should not match itemscopes with different names' do
    @md.search(%r{nothing}).size.should == 0
  end

  it 'should find the correct number of itemscopes' do
    @md.items.size.should == 1
  end
end

describe Mida::Document, 'when run with a document containing textContent and non textContent itemprops' do
  before do
    @html = '
      <html>
        <head itemscope>
          <link itemprop="link_field" rel="stylesheet" type="text/css" href="stylesheet.css" />
        </head>
        <body>
          There is some text here
          <div>
            and also some here
            <div itemscope>
              <span itemprop="span_field">Some span content</span>
              <time itemprop="dtreviewed" datetime="2009-01-06">Jan 6</time>.
              <meta itemprop="meta_field" content="Some meta content">
              <a itemprop="a_field1" href="http://example.com">non content</a>
              <a itemprop="a_field2" href="welcome/index.html">non content</a>
              <a itemprop="a_field3" href="/intro">non content</a>
              <a itemprop="a_field4" href="/intro/index.html">non content</a>
              <map name="somemap">
                <area shape="rect" coords="0,0,50,120" href="left.html" />
                <area itemprop="area_right" shape="rect" coords="51,0,120,120" href="right.html" />
              </map>
              <audio itemprop="audio_field" src="asound.ogg" controls="controls">
                Audio tag not supported by your browser.
              </audio>

              <embed itemprop="embed_field" src="helloworld.swf" />
              <iframe itemprop="iframe_field" src="http://www.example.com/iframe_test"></iframe>
              <img itemprop="img_field" src="animage.png" width="120" height="120" usemap="#planetmap" />
              <object itemprop="object_field" data="object.png" type="image/png" />
              <audio controls="controls">
                <source itemprop="source_field" src="song.ogg" type="audio/ogg" />
                <track itemprop="track_field" src="atrack.ogg" />
                Audio tag not supported by your browser.
              </audio>
              <video itemprop="video_field" src="movie.ogg" controls="controls">
                Video tag not supported by your browser.
              </video>
            </div>
          </div>
        </body>
      </html>
    '
  end


  context 'when not given a page_url' do
    before do
      @md = Mida::Document.new(@html)
    end

    it 'should return all the properties and types with the correct values' do
      expected_results = [
        { type: nil, id: nil, properties: {'link_field' => ['']} },
        { type: nil,
          id: nil,
          properties: {
            'span_field' => ['Some span content'],
            'dtreviewed' => ['2009-01-06'],
            'meta_field' => ['Some meta content'],
            'a_field1' => ['http://example.com'],
            'a_field2' => [''],
            'a_field3' => [''],
            'a_field4' => [''],
            'area_right' => [''],
            'audio_field' => [''],
            'embed_field' => [''],
            'iframe_field' => ['http://www.example.com/iframe_test'],
            'img_field' => [''],
            'object_field' => [''],
            'source_field' => [''],
            'track_field' => [''],
            'video_field' => ['']
          }
        }
      ]

      test_parsing(@md, %r{}, expected_results)

    end
  end

  context 'when given a page_url' do
    before do
      @md = Mida::Document.new(@html, 'http://example.com/start/')
    end

    it 'should return all the properties and types with the correct values' do
      expected_results = [
        { type: nil, id: nil, properties: {
          'link_field' => ['http://example.com/start/stylesheet.css']
          }
        },
        { type: nil,
          id: nil,
          properties: {
            'span_field' => ['Some span content'],
            'dtreviewed' => ['2009-01-06'],
            'meta_field' => ['Some meta content'],
            'a_field1' => ['http://example.com'],
            'a_field2' => ['http://example.com/start/welcome/index.html'],
            'a_field3' => ['http://example.com/intro'],
            'a_field4' => ['http://example.com/intro/index.html'],
            'area_right' => ['http://example.com/start/right.html'],
            'audio_field' => ['http://example.com/start/asound.ogg'],
            'embed_field' => ['http://example.com/start/helloworld.swf'],
            'iframe_field' => ['http://www.example.com/iframe_test'],
            'img_field' => ['http://example.com/start/animage.png'],
            'object_field' => ['http://example.com/start/object.png'],
            'source_field' => ['http://example.com/start/song.ogg'],
            'track_field' => ['http://example.com/start/atrack.ogg'],
            'video_field' => ['http://example.com/start/movie.ogg']
          }
        }
      ]

      test_parsing(@md, %r{}, expected_results)
    end
  end

end

describe Mida::Document, 'when run against a full html document containing one itemscope with no itemtype' do

  before do
    html = '
      <html><body>
        There is some text here
        <div>
          and also some here
          <div itemscope>
            <span itemprop="itemreviewed">Romeo Pizza</span>
            Reviewed by <span itemprop="reviewer">Ulysses Grant</span> on
            <time itemprop="dtreviewed" datetime="2009-01-06">Jan 6</time>.
            <meta itemprop="fielda" content="a5482">

            <span itemprop="summary">Delicious, tasty pizza in Eastlake!</span>
            <span itemprop="description">This is a very nice pizza place.</span>
            Rating: <span itemprop="rating">4.5</span>
          </div>
        </div>
      </body></html>
    '
    @md = Mida::Document.new(html)

  end

  it_should_behave_like 'one root itemscope'

  it 'should return all the properties and types with the correct values' do
    expected_results = [{
      type: nil,
      id: nil,
      properties: {
        'itemreviewed' => ['Romeo Pizza'],
        'reviewer' => ['Ulysses Grant'],
        'dtreviewed' => ['2009-01-06'],
        'fielda' => ['a5482'],
        'summary' => ['Delicious, tasty pizza in Eastlake!'],
        'description' => ['This is a very nice pizza place.'],
        'rating' => ['4.5']
      }
    }]

    test_parsing(@md, %r{}, expected_results)
  end

end

describe Mida::Document, 'when run against a full html document containing one itemscope nested within another' do

  before do
    html = '
      <html><body>
        There is some text here
        <div>
          and also some here
          <div itemscope>
            <span itemprop="itemreviewed">Romeo Pizza</span>
            <div itemprop="address" itemscope>
              <span itemprop="firstline">237 Italian Way</span>
              <span itemprop="country">United Kingdom</span>
            </div>
            Rating: <span itemprop="rating">4.5</span>
          </div>
        </div>
      </body></html>
    '

    @md = Mida::Document.new(html)

  end

  it_should_behave_like 'one root itemscope'

  it 'should return all the properties and types with the correct values' do
    expected_results = [{
      type: nil,
      id: nil,
      properties: {
        'itemreviewed' => ['Romeo Pizza'],
        'address' => [{
          type: nil, id: nil, properties: {
            'firstline' => ['237 Italian Way'],
            'country' => ['United Kingdom']
           }
        }],
        'rating' => ['4.5']
      }
    }]

    test_parsing(@md, %r{}, expected_results)
  end

end

describe Mida::Document, 'when run against a full html document containing one itemscope nested within another within another' do

  before do
    html = '
      <html><body>
        There is some text here
        <div>
          and also some here
          <div itemscope>
            <span itemprop="itemreviewed">Romeo Pizza</span>
            <div itemprop="address" itemscope>
              <div itemprop="firstline" itemscope>
                <span itemprop="number">237</span>
                <span itemprop="road">Italian Way</span>
              </div>
              <span itemprop="country">United Kingdom</span>
            </div>
            Rating: <span itemprop="rating">4.5</span>
          </div>
        </div>
      </body></html>
    '

    @md = Mida::Document.new(html)
  end

  it_should_behave_like 'one root itemscope'

  it 'should return all the properties and types with the correct values' do
    expected_results = [{
      type: nil,
      id: nil,
      properties: {
        'itemreviewed' => ['Romeo Pizza'],
        'address' => [{
          type: nil,
          id: nil,
          properties: {
            'firstline' => [{
              type: nil,
              id: nil,
              properties: {
                'number' => ['237'],
                'road' => ['Italian Way']
              },
            }],
            'country' => ['United Kingdom']
          },
        }],
        'rating' => ['4.5']
      }
    }]

    test_parsing(@md, %r{^$}, expected_results)
  end

end

describe Mida::Document, 'when run against a full html document containing one itemscope with an itemtype' do

  before do
    html = '
      <html><body>
        There is some text here
        <div>
          and also some here
          <div itemscope itemtype="http://data-vocabulary.org/Review">
            <span itemprop="itemreviewed">Romeo Pizza</span>
            Reviewed by <span itemprop="reviewer">Ulysses Grant</span> on
            <time itemprop="dtreviewed" datetime="2009-01-06">Jan 6</time>.
            <span itemprop="summary">Delicious, tasty pizza in Eastlake!</span>
            <span itemprop="description">This is a very nice pizza place.</span>
            Rating: <span itemprop="rating">4.5</span>
          </div>
        </div>
      </body></html>
    '

    @md = Mida::Document.new(html)

  end

  it_should_behave_like 'one root itemscope'

  it 'should find the correct number of itemscopes if outer specified' do
    @md.search(%r{http://data-vocabulary.org/Review}).size.should == 1
  end

  it 'should specify the correct type' do
    @md.search(%r{http://data-vocabulary.org/Review}).first.type.should == 'http://data-vocabulary.org/Review'
  end

  it 'should return all the properties and types with the correct values' do
    expected_results = [{
      type: 'http://data-vocabulary.org/Review',
      id: nil,
      properties: {
        'itemreviewed' => ['Romeo Pizza'],
        'reviewer' => ['Ulysses Grant'],
        'dtreviewed' => ['2009-01-06'],
        'summary' => ['Delicious, tasty pizza in Eastlake!'],
        'description'  => ['This is a very nice pizza place.'],
        'rating' => ['4.5']
      }
    }]
    test_parsing(@md, %r{http://data-vocabulary.org/Review}, expected_results)
  end

end

describe Mida::Document, 'when run against a full html document containing two non-nested itemscopes with itemtypes' do

  before do
    html = '
      <html><body>
        There is some text here
        <div>
          and also some here
          <div itemscope itemtype="http://data-vocabulary.org/Review">
            <span itemprop="itemreviewed">Romeo Pizza</span>
            Rating: <span itemprop="rating">4.5</span>
          </div>
          <div itemscope itemtype="http://data-vocabulary.org/Organization">
            <span itemprop="name">An org name</span>
            <span itemprop="url">http://example.com</span>
          </div>
        </div>
      </body></html>
    '

    @md = Mida::Document.new(html)

  end

  it 'should return all the itemscopes' do
    @md.items.size.should == 2
  end

  it 'should give the type of each itemscope if none specified' do
    itemscope_names = {
      'http://data-vocabulary.org/Review' => 0,
      'http://data-vocabulary.org/Organization' => 0
    }

    @md.items.each do |item|
      itemscope_names[item.type] += 1
    end

    itemscope_names.size.should eq 2
    itemscope_names.each { |name, num| num.should == 1 }
  end


  it 'should return all the properties and types with the correct values for 1st itemscope' do
    expected_results = [{
      type: 'http://data-vocabulary.org/Review',
      id: nil,
      properties: {
        'itemreviewed' => ['Romeo Pizza'],
        'rating' => ['4.5']
      }
    }]
    test_parsing(@md, %r{http://data-vocabulary.org/Review}, expected_results)
  end

  it 'should return all the properties from the text for 2nd itemscope' do
    expected_results = [{
      type: 'http://data-vocabulary.org/Organization',
      id: nil,
      properties: {
        'name' => ['An org name'],
        'url' => ['http://example.com']
      }
    }]
    test_parsing(@md, %r{http://data-vocabulary.org/Organization}, expected_results)
  end

end

describe Mida::Document, 'when run against a full html document containing one
  itemscope nested within another and the inner block is
  surrounded with another non itemscope block' do

  before do
    html = '
      <html><body>
        <div itemscope itemtype="http://data-vocabulary.org/Product">
          <ul class="reviews">
            <li id="model" itemprop="name">DC07</li>
            <li id="make" itemprop="brand">Dyson</li>
            <li itemprop="review" itemscope itemtype="http://data-vocabulary.org/Review-aggregate">
              <span class="ratingDetails">
                <span itemprop="count">1</span> Review,
                Average: <span itemprop="rating">5.0</span>
              </span>
            </li>
          </ul>
        </div>
      </body></html>
    '

    @md = Mida::Document.new(html)
  end

  it_should_behave_like 'one root itemscope'

  it 'should return the correct number of itemscopes' do
    vocabularies = [
      %r{http://data-vocabulary.org/Product},
      %r{http://data-vocabulary.org/Review-aggregate}
    ]
    vocabularies.each {|vocabulary| @md.search(vocabulary).size.should == 1}
  end

  context "when looking at the outer vocabulary" do
    it 'should return all the properties from the text with the correct values' do
      expected_results = [{
        type: 'http://data-vocabulary.org/Product',
        id: nil,
        properties: {
          'name' => ['DC07'],
          'brand' => ['Dyson'],
          'review' => [{
            type: 'http://data-vocabulary.org/Review-aggregate',
            id: nil,
            properties: {
              'count' => ['1'],
              'rating' => ['5.0']
            }
          }]
        }
      }]

      test_parsing(@md, %r{http://data-vocabulary.org/Product}, expected_results)
    end
  end

end

describe Mida::Document, 'when run against a document containing an itemscope
  that contains another non-linked itemscope' do

  before do
    html = '
      <html><body>
        <div itemscope itemtype="http://data-vocabulary.org/Product">
          <ul class="reviews">
            <li id="model" itemprop="name">DC07</li>
            <li id="make" itemprop="brand">Dyson</li>
            <li itemscope itemtype="http://data-vocabulary.org/Review-aggregate">
              <span class="ratingDetails">
                <span itemprop="count">1</span> Review,
                Average: <span itemprop="rating">5.0</span>
              </span>
            </li>
          </ul>
        </div>
      </body></html>
    '

    @md = Mida::Document.new(html)
  end

  it 'should return the correct number of itemscopes when search used' do
    vocabularies = {
      %r{} => 2,
      %r{http://data-vocabulary.org/Product} => 1,
      %r{http://data-vocabulary.org/Review-aggregate} => 1
    }
    vocabularies.each {|vocabulary, num| @md.search(vocabulary).size.should == num}
  end

  it 'should return the correct number of items' do
    @md.items.size.should == 2
  end

  context "when no vocabulary specified or looking at the outer vocabulary" do
    it 'should return all the properties from the text with the correct values' do
      pending("get the contains: feature working")
      expected_result = {
        type: 'http://data-vocabulary.org/Product',
        id: nil,
        properties: {
          'name' => 'DC07',
          'brand' => 'Dyson'
        },
        contains: {
          type: 'http://data-vocabulary.org/Review-aggregate',
          id: nil,
          properties: {
            'count' => '1',
            'rating' => '5.0'
          }
        }
      }

      @md.search('http://data-vocabulary.org/Product').first.should == expected_result
    end
  end
end

describe Mida::Document, 'when run against a document using itemrefs' do

  before do
    html = '
      <html><body>
        <div itemscope id="amanda" itemref="a b">
          <span itemprop="age">30</span>
        </div>
        <p id="a">Name: <span itemprop="name">Amanda</span></p>
        <div id="b" itemprop="band" itemscope itemref="c"></div>
        <div id="c">
          <p>Band: <span itemprop="name">Jazz Band</span></p>
          <p>Size: <span itemprop="size">12</span> players</p>
        </div>
      </body></html>
    '

    @md = Mida::Document.new(html)
  end

  it 'should return all the properties from the text with the correct values' do
    expected_results = [{
      type: nil,
      id: nil,
      properties: {
        'name' => ['Amanda'],
        'band' => [{
          type: nil,
          id: nil,
          properties: {
            'name' => ['Jazz Band'],
            'size' => ['12']
          }
        }],
        'age' => ['30']
      }
    }]

    test_parsing(@md, %r{}, expected_results)
  end
end

describe Mida::Document, 'when run against a document using multiple itemprops with the same name' do

  before do
    html = '
      <html><body>
        <div itemscope itemtype="icecreams">
          <p>Flavours in my favourite ice cream:</p>
          <ul>
            <li itemprop="flavour">Lemon sorbet</li>
            <li itemprop="flavour">Apricot sorbet</li>
            <li itemprop="flavour" itemscope itemtype="icecream-type">
              <span itemprop="fruit">Strawberry</span>
              <span itemprop="style">Homemade</span>
            </li>
          </ul>
        </div>
      </body></html>
    '

    @md = Mida::Document.new(html)
  end

  it_should_behave_like 'one root itemscope'

  it 'should return the correct number of itemscopes' do
    vocabularies = [
      %r{icecreams},
      %r{icecream-type}
    ]
    vocabularies.each {|vocabulary| @md.search(vocabulary).size.should == 1}
  end

  it 'should return all the properties from the text with the correct values' do
    expected_results = [{
      type: 'icecreams',
      id: nil,
      properties: {
        'flavour' => [
          'Lemon sorbet',
          'Apricot sorbet',
          { type: 'icecream-type',
            id: nil,
            properties: {
              'fruit' => ['Strawberry'],
              'style' => ['Homemade']
            }
          }
        ]
      }
    }]

    test_parsing(@md, %r{icecreams}, expected_results)
  end
end

describe Mida::Document, 'when run against a document using an itemprop with multiple properties' do

  before do
    html = '
      <html><body>
        <div itemscope>
          <span itemprop="favourite-colour favourite-fruit">orange</span>
        </div>
      </body></html>
    '

    @md = Mida::Document.new(html)
  end

  it 'should return all the properties from the text with the correct values' do
    expected_results = [{
      type: nil,
      id: nil,
      properties: {
        'favourite-colour' => ['orange'],
        'favourite-fruit' => ['orange']
      }
    }]

    test_parsing(@md, %r{}, expected_results)
  end
end
