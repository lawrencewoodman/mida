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
