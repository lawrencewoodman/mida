require 'spec_helper'
require 'mida/item'
require 'mida/vocabulary'

describe Mida::Item, 'when initialized with an incomplete itemscope' do
  before do
    itemscope = mock(Mida::Itemscope)
    itemscope.stub!(:type).and_return(nil)
    itemscope.stub!(:id).and_return(nil)
    itemscope.stub!(:properties).and_return({})
    @item = Mida::Item.new(itemscope)
  end

  it '#type should return the same type as the itemscope' do
    @item.type.should == nil
  end

  it '#vocabulary should return the correct vocabulary' do
    @item.vocabulary.should == Mida::GenericVocabulary
  end

  it '#id should return the same id as the itemscope' do
    @item.id.should == nil
  end

  it '#properties should return the same properties as the itemscope' do
    @item.properties.should == {}
  end

  it '#to_h should return the correct type and properties' do
    @item.to_h.should == {
      type: nil,
      id: nil,
      properties: {}
    }
  end
end

describe Mida::Item, 'when initialized with a complete itemscope of an unknown type' do
  before do
    itemscope = mock(Mida::Itemscope)
    itemscope.stub!(:type).and_return("book")
    itemscope.stub!(:id).and_return("urn:isbn:978-1-849510-50-9")
    itemscope.stub!(:properties).and_return(
      {'first_name' => ['Lorry'], 'last_name' => ['Woodman']}
    )
    @item = Mida::Item.new(itemscope)
  end

  it '#type should return the same type as the itemscope' do
    @item.type.should == "book"
  end

  it '#vocabulary should return the correct vocabulary' do
    @item.vocabulary.should == Mida::GenericVocabulary
  end

  it '#id should return the same id as the itemscope' do
    @item.id.should == "urn:isbn:978-1-849510-50-9"
  end

  it '#properties should return the same properties as the itemscope' do
    @item.properties.should == {
      'first_name' => ['Lorry'],
      'last_name' => ['Woodman']
    }
  end

  it '#to_h should return the correct type and properties' do
    @item.to_h.should == {
      type: 'book',
      id: "urn:isbn:978-1-849510-50-9",
      properties: {
        'first_name' => ['Lorry'],
        'last_name' => ['Woodman']
      }
    }
  end
end

describe Mida::Item, 'when initialized with an itemscope of a known type' do
  before do
    class Person < Mida::Vocabulary
      itemtype %r{http://example.com/vocab/person}
      has_one 'name'
      has_many 'url'
    end

    itemscope = mock(Mida::Itemscope)
    itemscope.stub!(:type).and_return("http://example.com/vocab/person")
    itemscope.stub!(:id).and_return(nil)
    itemscope.stub!(:properties).and_return(
      { 'name' => ['Lorry Woodman'],
        'url' => ['http://example.com/user/lorry']
      }
    )
    @item = Mida::Item.new(itemscope)
  end

  it '#vocabulary should return the correct vocabulary' do
    @item.vocabulary.should == Person
  end

  it '#properties should return the same properties as the itemscope' do
    @item.properties.should == {
      'name' => 'Lorry Woodman',
      'url' => ['http://example.com/user/lorry']
    }
  end

  it '#to_h should return the correct type and properties' do
    @item.to_h.should == {
      type: 'http://example.com/vocab/person',
      id: nil,
      properties: {
        'name' => 'Lorry Woodman',
        'url' => ['http://example.com/user/lorry']
      }
    }
  end

end

describe Mida::Item, 'when initialized with an itemscope of a known type' do
  before do
    class Person < Mida::Vocabulary
      itemtype %r{http://example.com/vocab/person}
      has_one 'name'
      has_many 'url'
    end

    itemscope = mock(Mida::Itemscope)
    itemscope.stub!(:type).and_return("http://example.com/vocab/person")
    itemscope.stub!(:id).and_return(nil)
    itemscope.stub!(:properties).and_return(
      { 'name' => ['Lorry Woodman'],
        'url' => ['http://example.com/user/lorry']
      }
    )
    @item = Mida::Item.new(itemscope)
  end

  it '#vocabulary should return the correct vocabulary' do
    @item.vocabulary.should == Person
  end

  it 'should return has_one properties as a single value' do
    @item.properties['name'].should == 'Lorry Woodman'
  end

  it 'should return has_many properties as an array' do
    @item.properties['url'].should == ['http://example.com/user/lorry']
  end

  it '#properties should return the same properties as the itemscope' do
    @item.properties.should == {
      'name' => 'Lorry Woodman',
      'url' => ['http://example.com/user/lorry']
    }
  end

  it '#to_h should return the correct type and properties' do
    @item.to_h.should == {
      type: 'http://example.com/vocab/person',
      id: nil,
      properties: {
        'name' => 'Lorry Woodman',
        'url' => ['http://example.com/user/lorry']
      }
    }
  end

end

describe Mida::Item, 'when initialized with an itemscope of a known type that does not fully match vocabulary' do
  before do
    # Make sure the class is redefined afresh to make sure that
    # inherited() hook is called
    Mida::Vocabulary.unregister(Person)
    Object.send(:remove_const, :Person)
    class Person < Mida::Vocabulary
      itemtype %r{http://example.com/vocab/person}
      has_one 'name', 'tel'
      has_many 'url', 'city'
    end

    itemscope = mock(Mida::Itemscope)
    itemscope.stub!(:type).and_return("http://example.com/vocab/person")
    itemscope.stub!(:id).and_return(nil)
    itemscope.stub!(:properties).and_return(
      { 'name' => ['Lorry Woodman'],
        'tel' => ['000004847582', '111111857485'],
        'url' => ['http://example.com/user/lorry'],
        'city' => ['Bristol']
      }
    )
    @item = Mida::Item.new(itemscope)
  end

  it '#vocabulary should return the correct vocabulary' do
    @item.vocabulary.should == Person
  end

  it 'should not keep properties that have too many values' do
    @item.properties.should_not have_key('tel')
  end

  it 'should keep have_many properties even if they have only one value' do
    @item.properties.should have_key('city')
  end

end

describe Mida::Item, 'when initialized with an itemscope containing another correct itemscope' do
  before do
    class Tel < Mida::Vocabulary
      itemtype %r{http://example.com/vocab/tel}
      has_one 'dial_code', 'number'
    end

    class Person < Mida::Vocabulary
      itemtype %r{http://example.com/vocab/person}
      has_one 'name'
      has_many 'tel' do
        extract Tel, Mida::DataType::Text
      end
    end

    tel_itemscope = mock(Mida::Itemscope)
    tel_itemscope.stub!(:kind_of?).any_number_of_times.with(Mida::Itemscope).and_return(true)
    tel_itemscope.stub!(:type).and_return("http://example.com/vocab/tel")
    tel_itemscope.stub!(:id).and_return(nil)
    tel_itemscope.stub!(:properties).and_return(
      { 'dial_code' => ['0248583'],
        'number' => ['000004847582'],
      }
    )
    person_itemscope = mock(Mida::Itemscope)
    person_itemscope.stub!(:type).and_return("http://example.com/vocab/person")
    person_itemscope.stub!(:id).and_return(nil)
    person_itemscope.stub!(:properties).and_return(
      { 'name' => ['Lorry Woodman'],
        'tel' => ['000004847582', tel_itemscope],
      }
    )
    @item = Mida::Item.new(person_itemscope)
  end

  it '#vocabulary should return the correct vocabulary' do
    @item.vocabulary.should == Person
  end

  it 'should validate and convert the nested itemscope' do
    @item.properties['tel'][1].vocabulary.should == Tel
    @item.properties['tel'][1].properties.should == {
      'dial_code' => '0248583',
      'number' => '000004847582',
    }
  end

  it 'should accept the text tel' do
    @item.properties['tel'][0].should == '000004847582'
  end

end

describe Mida::Item, 'when initialized with an itemscope containing another invalid itemscope' do
  before do
    class Person < Mida::Vocabulary
      itemtype %r{http://example.com/vocab/person}
      has_one 'name'
      has_many 'tel'
    end

    tel_itemscope = mock(Mida::Itemscope)
    tel_itemscope.stub!(:kind_of?).any_number_of_times.with(Mida::Itemscope).and_return(true)
    tel_itemscope.stub!(:type).and_return("http://example.com/vocab/tel")
    tel_itemscope.stub!(:id).and_return(nil)
    tel_itemscope.stub!(:properties).and_return(
      { 'dial_code' => ['0248583'],
        'number' => ['000004847582'],
      }
    )
    person_itemscope = mock(Mida::Itemscope)
    person_itemscope.stub!(:type).and_return("http://example.com/vocab/person")
    person_itemscope.stub!(:id).and_return(nil)
    person_itemscope.stub!(:properties).and_return(
      { 'name' => ['Lorry Woodman'],
        'tel' => ['000004847582', tel_itemscope],
      }
    )
    @item = Mida::Item.new(person_itemscope)
  end

  it 'should only accept values of the correct type' do
    @item.properties['tel'].size.should == 1
    @item.properties['tel'][0].should == '000004847582'
  end

end
