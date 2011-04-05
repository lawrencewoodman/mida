require_relative 'spec_helper'
require_relative '../lib/mida'

describe MiDa::Item, 'when initialized with an itemscope' do
  before do
    # The first_name element
    @fn = mock_element('span', {'itemprop' => 'first_name'}, 'Lorry')

    # The last_name element
    @ln = mock_element('span', {'itemprop' => 'last_name'}, 'Woodman')
  end

  context 'when there is no itemtype' do
    before do
      # The surrounding reviewer itemscope element
      @itemscope_el = mock_element('div', {'itemprop' => 'reviewer', 'itemscope' => true}, nil, [@fn,@ln])
    end

    it '#type should return the correct type' do
      item = MiDa::Item.new(@itemscope_el, "")
      item.type.should == nil
    end

    it '#properties should return the correct name/value pairs' do
      item = MiDa::Item.new(@itemscope_el, "")
      item.properties.should == {'first_name' => 'Lorry', 'last_name' => 'Woodman'}
    end

    it '#to_h should return the correct type and properties' do
      item = MiDa::Item.new(@itemscope_el, "")
      item.to_h.should == {type: nil, properties: {'first_name' => 'Lorry', 'last_name' => 'Woodman'}}
    end
  end

  context 'when there is an itemtype' do
    before do
      # The surrounding reviewer itemscope element
      @itemscope_el = mock_element('div', {'itemprop' => 'reviewer', 'itemtype' => 'person', 'itemscope' => true}, nil, [@fn,@ln])
    end

    it '#type should return the correct type' do
      item = MiDa::Item.new(@itemscope_el, "")
      item.type.should == 'person'
    end

    it '#properties should return the correct name/value pairs' do
      item = MiDa::Item.new(@itemscope_el, "")
      item.properties.should == {'first_name' => 'Lorry', 'last_name' => 'Woodman'}
    end

    it '#to_h should return the correct type and properties' do
      item = MiDa::Item.new(@itemscope_el, "")
      item.to_h.should == {type: 'person', properties: {'first_name' => 'Lorry', 'last_name' => 'Woodman'}}
    end
  end
end
