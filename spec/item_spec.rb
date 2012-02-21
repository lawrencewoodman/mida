require 'spec_helper'
require 'mida/item'
require 'mida_vocabulary/vocabulary'

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

  it '#to_h should return an empty hash' do
    @item.to_h.should == {}
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

  it '#to_h should return the correct type, id and properties' do
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
      has_many 'date' do
        extract Mida::DataType::ISO8601Date, Mida::DataType::Text
      end
      has_many 'url' do
        extract Mida::DataType::URL
      end
    end

    itemscope = mock(Mida::Itemscope)
    itemscope.stub!(:type).and_return("http://example.com/vocab/person")
    itemscope.stub!(:id).and_return(nil)
    itemscope.stub!(:properties).and_return(
      { 'name' => ['Lorry Woodman'],
        'date' => ['2nd October 2009', '2009-10-02'],
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
    @item.properties['url'].length == 1
    @item.properties['url'].first.to_s.should == 'http://example.com/user/lorry'
  end

  it 'should accept datatypes that are valid' do
    @item.properties['date'][0].should == '2nd October 2009'
  end

  it 'should accept datatypes that are valid' do
    @item.properties['date'][1].should.to_s == Date.iso8601('2009-10-02').rfc822
  end

  it '#properties should return the same properties as the itemscope' do
    @item.properties.keys.should == ['name', 'date', 'url']
    @item.properties['date'].length == 2
  end

  it '#to_h should return the correct type and properties' do
    @item.to_h.should == {
      type: 'http://example.com/vocab/person',
      properties: @item.properties
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
      has_one 'dob' do
        extract Mida::DataType::ISO8601Date
      end
    end

    itemscope = mock(Mida::Itemscope)
    itemscope.stub!(:type).and_return("http://example.com/vocab/person")
    itemscope.stub!(:id).and_return(nil)
    itemscope.stub!(:properties).and_return(
      { 'name' => ['Lorry Woodman'],
        'tel' => ['000004847582', '111111857485'],
        'url' => ['http://example.com/user/lorry'],
        'city' => ['Bristol'],
        'dob' => 'When I was born'
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

  it 'should not keep properties that have the wrong DataType' do
    @item.properties.should_not have_key('dob')
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

    tel_itemscope = Mida::Itemscope.allocate
    tel_itemscope.instance_variable_set(:@type, "http://example.com/vocab/tel")
    tel_itemscope.instance_variable_set(:@id, nil)
    tel_itemscope.instance_variable_set(:@properties, 'dial_code' => ['0248583'], 'number' => ['000004847582'])
    
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

  it "#to_h shouldnt return nested items properly" do
    @item.to_h.should == {
      type: 'http://example.com/vocab/person',
      properties: {
        'name' => 'Lorry Woodman',
        'tel' => [ '000004847582',
                   { type: 'http://example.com/vocab/tel',
                     properties: { 'dial_code' => '0248583',
                                   'number' => '000004847582'
                     }
                   }
        ]
      }
    }
  end

end

describe Mida::Item, 'when initialized with an itemscope that has a property type that is a child of the specified type' do
  before do
    class Person < Mida::Vocabulary
      itemtype %r{http://example.com/vocab/person}
      has_one 'name'
      has_many 'tel'
    end

    class Student < Mida::Vocabulary
      itemtype %r{http://example.com/vocab/student}
      include_vocabulary Person
      has_one 'studying'
    end

    class Organization < Mida::Vocabulary
      itemtype %r{http://example.com/vocab/organization}
      has_one 'name'
      has_many 'employee' do
        extract Person
      end
    end

    student_itemscope = mock(Mida::Itemscope)
    student_itemscope.stub!(:kind_of?).any_number_of_times.with(Mida::Itemscope).and_return(true)
    student_itemscope.stub!(:type).and_return("http://example.com/vocab/student")
    student_itemscope.stub!(:id).and_return(nil)
    student_itemscope.stub!(:properties).and_return(
      { 'name' => ['Lorry Woodman'],
        'tel' => ['000004847582'],
        'studying' => ['Classics']
      }
    )

    org_itemscope = mock(Mida::Itemscope)
    org_itemscope.stub!(:kind_of?).any_number_of_times.with(Mida::Itemscope).and_return(true)
    org_itemscope.stub!(:type).and_return("http://example.com/vocab/organization")
    org_itemscope.stub!(:id).and_return(nil)
    org_itemscope.stub!(:properties).and_return(
      { 'name' => ['Acme Inc.'],
        'employee' => [student_itemscope]
      }
    )
    @item = Mida::Item.new(org_itemscope)
  end

  it 'should recognise an itemtype that is the child of that specified' do
    @item.properties['employee'][0].vocabulary.should == Student
    @item.properties['employee'][0].type.should == 'http://example.com/vocab/student'
    @item.properties['employee'][0].properties.should == {
      'name' => 'Lorry Woodman',
      'tel' => ['000004847582'],
      'studying' => 'Classics'
    }
  end

end

describe Mida::Item, 'when initialized with an itemscope containing another invalid itemscope' do
  before do
    # Make sure the class is redefined afresh to make sure that
    # inherited() hook is called
    Mida::Vocabulary.unregister(Person)
    Object.send(:remove_const, :Person)
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

describe Mida::Item, 'when validating wrong datas' do
  it "should get item" do
    content = '
    <html>
    <head></head>
    <body itemscope itemtype="http://schema.org/Person">
      <time itemprop="birthDate" datetime="1 day before me">wrong datatype</time>

      <span itemscope itemprop="children" itemtype="http://schema.org/Zoo">
        <h2 itemtype="name">Cat</h2>
      </span>
    </body
    </html>
    '
    doc = Mida::Document.new(content, 'http://example.com')

    errors = doc.errors

    errors[0][:item].should == doc.items[0]
    errors[0][:error].should == [:value, 'birthDate', :wrong_datatype, "1 day before me"]
    errors[1][:error][0..2].should == [:nested_item, 'children', :wrong_itemtype]
  end
end