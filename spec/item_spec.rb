require_relative 'spec_helper'
require_relative '../lib/mida'

describe Mida::Item, 'when initialized with an itemscope containing just itemprops' do
  before do
    # The first_name element
    @fn = mock_element('span', {'itemprop' => 'first_name'}, 'Lorry')

    # The last_name element
    @ln = mock_element('span', {'itemprop' => 'last_name'}, 'Woodman')
  end

  context 'when there is no itemtype' do
    before do
      # The surrounding reviewer itemscope element
      itemscope_el = mock_element('div', {'itemprop' => 'reviewer', 'itemscope' => true}, nil, [@fn,@ln])
      @item = Mida::Item.new(itemscope_el)
    end

    it '#type should return the correct type' do
      @item.type.should == nil
    end

    it '#properties should return the correct name/value pairs' do
      @item.properties.should == {
        'first_name' => ['Lorry'],
        'last_name' => ['Woodman']
      }
    end

    it '#to_h should return the correct type and properties' do
      @item.to_h.should == {
        type: nil, properties: {
          'first_name' => ['Lorry'],
          'last_name' => ['Woodman']
        }
      }
    end
  end

  context 'when there is an itemtype' do
    before do
      # The surrounding reviewer itemscope element
      itemscope_el = mock_element('div', {'itemprop' => 'reviewer', 'itemtype' => 'person', 'itemscope' => true}, nil, [@fn,@ln])
      @item = Mida::Item.new(itemscope_el)
    end

    it '#type should return the correct type' do
      @item.type.should == 'person'
    end

    it '#properties should return the correct name/value pairs' do
      @item.properties.should == {
        'first_name' => ['Lorry'],
        'last_name' => ['Woodman']
      }
    end

    it '#to_h should return the correct type and properties' do
      @item.to_h.should == {
        type: 'person',
        properties: {
          'first_name' => ['Lorry'],
          'last_name' => ['Woodman']
        }
      }
    end
  end
end

describe Mida::Item, 'when initialized with an itemscope containing an itemprop with a relative url' do
  before do
    @url = mock_element('a', {'itemprop' => 'url', 'href' => 'home/lorry'})
    itemscope_el = mock_element('div', {'itemscope' => true}, nil, [@url])
    @item = Mida::Item.new(itemscope_el, "http://example.com")
  end

  it 'should return the url as an absolute url' do
    @item.properties['url'].should == ['http://example.com/home/lorry']
  end
end

describe Mida::Item, 'when initialized with an itemscope containing itemprops surrounded by a non microdata element' do
  before do
    # The first_name element
    fn = mock_element('span', {'itemprop' => 'first_name'}, 'Lorry')

    # The last_name element
    ln = mock_element('span', {'itemprop' => 'last_name'}, 'Woodman')

    # A non microdata element surrounding last_name
    surround = mock_element('span', {}, nil, [ln])

    # The surrounding reviewer itemscope element
    itemscope_el = mock_element('div', {'itemprop' => 'reviewer',
                                        'itemtype' => 'person',
                                        'itemscope' => true},
                                nil, [fn,surround])
    @item = Mida::Item.new(itemscope_el)
  end

  it '#type should return the correct type' do
    @item.type.should == 'person'
  end

  it '#properties should return the correct name/value pairs' do
    @item.properties.should == {
      'first_name' => ['Lorry'],
      'last_name' => ['Woodman']
    }
  end

  it '#to_h should return the correct type and properties' do
    @item.to_h.should == {
      type: 'person',
      properties: {
        'first_name' => ['Lorry'],
        'last_name' => ['Woodman']
      }
    }
  end

end

describe Mida::Item, 'when initialized with an itemscope containing itemprops with the same name' do
  before do
    # Lemon Sorbet flavour
    ls_flavour = mock_element('span', {'itemprop' => 'flavour'}, 'Lemon Sorbet')

    # Apricot Sorbet flavour
    as_flavour = mock_element('span', {'itemprop' => 'flavour'}, 'Apricot Sorbet')

    # Strawberry icecream
    fruit = mock_element('span', {'itemprop' => 'fruit'}, 'Strawberry')

    # Homemade icecream
    style = mock_element('span', {'itemprop' => 'style'}, 'Homemade')

    # The surrounding icecreame-type itemscope
    @sb_flavour = mock_element('div', {'itemprop' => 'flavour',
                                       'itemtype' => 'icecream-type',
                                       'itemscope' => true},
                               nil, [fruit,style])

    # The surrounding icecreams itemscope element
    icecreams = mock_element('div', {'itemtype' => 'icecreams',
                                     'itemscope' => true},
                             nil, [ls_flavour, as_flavour, @sb_flavour])
    @item = Mida::Item.new(icecreams)
  end

  it '#type should return the correct type' do
    @item.type.should == 'icecreams'
  end

  it '#properties should return the correct name/value pairs' do
    @item.properties.should == {
      'flavour' => [
        'Lemon Sorbet',
        'Apricot Sorbet',
        Mida::Item.new(@sb_flavour)
      ]
    }
  end

  it '#to_h should return the correct type and properties' do
    @item.to_h.should == {
      type: 'icecreams',
      properties: {
        'flavour' => [
          'Lemon Sorbet',
          'Apricot Sorbet',
          { type: 'icecream-type',
            properties: {
              'fruit' => ['Strawberry'],
              'style' => ['Homemade']
            }
          }
        ]
      }
    }
  end

end

describe Mida::Item, 'when initialized with an itemscope containing itemrefs' do

  before do

    name = mock_element('span', {'itemprop' => 'name'}, 'Amanda')
    name_p = mock_element('p', {'id' => 'a'}, nil, [name])

    band_name = mock_element('span', {'itemprop' => 'band_name'}, 'Jazz Band')
    band_size = mock_element('span', {'itemprop' => 'band_size'}, '12')
    band_div = mock_element('div', {'id' => 'c'}, nil, [band_name, band_size])
    @empty_band_div = mock_element('div', {'id' => 'b',
                                          'itemprop' => 'band',
                                          'itemref' => 'c',
                                          'itemscope' => true},
                                  nil, [],
                                  {'c' => band_div})


    age = mock_element('span', {'itemprop' => 'age'}, '30')
    age_div = mock_element('div', {'itemref' => 'a b',
                                   'itemscope' => true},
                           nil, [age],
                           {'a' => name_p, 'b' => @empty_band_div})

    @item = Mida::Item.new(age_div)
  end

  it '#type should return the correct type' do
    @item.type.should == nil
  end

  it '#properties should return the correct name/value pairs' do
    @item.properties.should == {
      'age' => ['30'],
      'name' => ['Amanda'],
      'band' => [Mida::Item.new(@empty_band_div)]
    }
  end

  it '#to_h should return the correct type and properties' do
    @item.to_h.should == {
      type: nil,
      properties: {
        'age' => ['30'],
        'name' => ['Amanda'],
        'band' => [{
          type: nil,
          properties: {
            'band_name' => ['Jazz Band'],
            'band_size' => ['12']
          }
        }]
      }
    }
  end

end

describe Mida::Item, 'when initialized with an itemscope containing itemscopes as properties nested two deep' do
  before do

    # The name of the item reviewed
    @item_name = mock_element('span', {'itemprop' => 'item_name'}, 'Acme Anvil')

    # The rating of the item
    @rating = mock_element('span', {'itemprop' => 'rating'}, '5')

    # The first_name
    @fn = mock_element('span', {'itemprop' => 'first_name'}, 'Lorry')

    # The last_name
    @ln = mock_element('span', {'itemprop' => 'last_name'}, 'Woodman')

    # The organization name
    @org_name = mock_element('span', {'itemprop' => 'name'}, 'Acme')

    # The surrounding organization itemscope
    @org_el = mock_element('div', {'itemprop' => 'represents',
                                   'itemtype' => 'organization',
                                   'itemscope' => true}, nil, [@org_name])

    # The surrounding reviewer itemscope
    @reviewer_el = mock_element('div', {'itemprop' => 'reviewer',
                                        'itemtype' => 'person',
                                        'itemscope' => true},
                                nil, [@fn,@ln, @org_el])

    # The surrounding reviewer itemscope
    @review_el = mock_element('div', {'itemtype' => 'review', 'itemscope' => true}, nil, [@item_name, @rating, @reviewer_el])

    @item = Mida::Item.new(@review_el)

  end

  before do
  end

  it '#type should return the correct type' do
    @item.type.should == 'review'
  end

  it '#properties should return the correct name/value pairs' do
    @item.properties.should == {
      'item_name' => ['Acme Anvil'],
      'rating' => ['5'],
      'reviewer' => [Mida::Item.new(@reviewer_el)]
    }
  end

  it '#to_h should return the correct type and properties' do
    @item.to_h.should == {
      type: 'review',
      properties: {
        'item_name' => ['Acme Anvil'],
        'rating' => ['5'],
        'reviewer' => [{
          type: 'person',
          properties: {
            'first_name' => ['Lorry'],
            'last_name' => ['Woodman'],
            'represents' => [{
              type: 'organization',
              properties: {
                'name' => ['Acme']
              }
           }]
          }
        }]
      }
    }
  end
end
