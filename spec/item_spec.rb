require 'spec_helper'
require 'mida/item'
require 'mida/vocabulary'

describe Mida::Item, 'when initialized with an incomplete itemscope' do
  before do
    itemscope = double(Mida::Itemscope)
    allow(itemscope).to receive(:type).and_return(nil)
    allow(itemscope).to receive(:id).and_return(nil)
    allow(itemscope).to receive(:properties).and_return({})
    @item = Mida::Item.new(itemscope)
  end

  it '#type should return the same type as the itemscope' do
    expect(@item.type).to eq(nil)
  end

  it '#vocabulary should return the correct vocabulary' do
    expect(@item.vocabulary).to eq(Mida::GenericVocabulary)
  end

  it '#id should return the same id as the itemscope' do
    expect(@item.id).to eq(nil)
  end

  it '#properties should return the same properties as the itemscope' do
    expect(@item.properties).to eq({})
  end

  it '#to_h should return an empty hash' do
    expect(@item.to_h).to eq({})
  end
end

describe Mida::Item, 'when initialized with a complete itemscope of an unknown type' do
  before do
    itemscope = double(Mida::Itemscope)
    allow(itemscope).to receive(:type).and_return("book")
    allow(itemscope).to receive(:id).and_return("urn:isbn:978-1-849510-50-9")
    allow(itemscope).to receive(:properties).and_return(
      {'first_name' => ['Lorry'], 'last_name' => ['Woodman']}
    )
    @item = Mida::Item.new(itemscope)
  end

  it '#type should return the same type as the itemscope' do
    expect(@item.type).to eq("book")
  end

  it '#vocabulary should return the correct vocabulary' do
    expect(@item.vocabulary).to eq(Mida::GenericVocabulary)
  end

  it '#id should return the same id as the itemscope' do
    expect(@item.id).to eq("urn:isbn:978-1-849510-50-9")
  end

  it '#properties should return the same properties as the itemscope' do
    expect(@item.properties).to eq({
      'first_name' => ['Lorry'],
      'last_name' => ['Woodman']
    })
  end

  it '#to_h should return the correct type, id and properties' do
    expect(@item.to_h).to eq({
      type: 'book',
      id: "urn:isbn:978-1-849510-50-9",
      properties: {
        'first_name' => ['Lorry'],
        'last_name' => ['Woodman']
      }
    })
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

    itemscope = double(Mida::Itemscope)
    allow(itemscope).to receive(:type).and_return("http://example.com/vocab/person")
    allow(itemscope).to receive(:id).and_return(nil)
    allow(itemscope).to receive(:properties).and_return(
      { 'name' => ['Lorry Woodman'],
        'date' => ['2nd October 2009', '2009-10-02'],
        'url' => ['http://example.com/user/lorry']
      }
    )
    @item = Mida::Item.new(itemscope)
  end

  it '#vocabulary should return the correct vocabulary' do
    expect(@item.vocabulary).to eq(Person)
  end

  it 'should return has_one properties as a single value' do
    expect(@item.properties['name']).to eq('Lorry Woodman')
  end

  it 'should return has_many properties as an array' do
    @item.properties['url'].length == 1
    expect(@item.properties['url'].first.to_s).to eq('http://example.com/user/lorry')
  end

  it 'should accept datatypes that are valid' do
    expect(@item.properties['date'][0]).to eq('2nd October 2009')
  end

  it 'should accept datatypes that are valid' do
    expect(@item.properties['date'][1].to_s).to eq Date.iso8601('2009-10-02').rfc822
  end

  it '#properties should return the same properties as the itemscope' do
    expect(@item.properties.keys).to eq(['name', 'date', 'url'])
    @item.properties['date'].length == 2
  end

  it '#to_h should return the correct type and properties' do
    expect(@item.to_h).to eq({
      type: 'http://example.com/vocab/person',
      properties: @item.properties
    })
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

    itemscope = double(Mida::Itemscope)
    allow(itemscope).to receive(:type).and_return("http://example.com/vocab/person")
    allow(itemscope).to receive(:id).and_return(nil)
    allow(itemscope).to receive(:properties).and_return(
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
    expect(@item.vocabulary).to eq(Person)
  end

  it 'should not keep properties that have too many values' do
    expect(@item.properties).not_to have_key('tel')
  end

  it 'should not keep properties that have the wrong DataType' do
    expect(@item.properties).not_to have_key('dob')
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

    tel_itemscope = double(Mida::Itemscope)
    allow(tel_itemscope).to receive(:kind_of?).with(Mida::Itemscope).and_return(true)
    allow(tel_itemscope).to receive(:type).and_return("http://example.com/vocab/tel")
    allow(tel_itemscope).to receive(:id).and_return(nil)
    allow(tel_itemscope).to receive(:properties).and_return(
      { 'dial_code' => ['0248583'],
        'number' => ['000004847582'],
      }
    )
    person_itemscope = double(Mida::Itemscope)
    allow(person_itemscope).to receive(:type).and_return("http://example.com/vocab/person")
    allow(person_itemscope).to receive(:id).and_return(nil)
    allow(person_itemscope).to receive(:properties).and_return(
      { 'name' => ['Lorry Woodman'],
        'tel' => ['000004847582', tel_itemscope],
      }
    )
    @item = Mida::Item.new(person_itemscope)
  end

  it '#vocabulary should return the correct vocabulary' do
    expect(@item.vocabulary).to eq(Person)
  end

  it 'should validate and convert the nested itemscope' do
    expect(@item.properties['tel'][1].vocabulary).to eq(Tel)
    expect(@item.properties['tel'][1].properties).to eq({
      'dial_code' => '0248583',
      'number' => '000004847582',
    })
  end

  it 'should accept the text tel' do
    expect(@item.properties['tel'][0]).to eq('000004847582')
  end

  it "#to_h shouldnt return nested items properly" do
    expect(@item.to_h).to eq({
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
    })
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

    student_itemscope = double(Mida::Itemscope)
    allow(student_itemscope).to receive(:kind_of?).with(Mida::Itemscope).and_return(true)
    allow(student_itemscope).to receive(:type).and_return("http://example.com/vocab/student")
    allow(student_itemscope).to receive(:id).and_return(nil)
    allow(student_itemscope).to receive(:properties).and_return(
      { 'name' => ['Lorry Woodman'],
        'tel' => ['000004847582'],
        'studying' => ['Classics']
      }
    )

    org_itemscope = double(Mida::Itemscope)
    allow(org_itemscope).to receive(:kind_of?).with(Mida::Itemscope).and_return(true)
    allow(org_itemscope).to receive(:type).and_return("http://example.com/vocab/organization")
    allow(org_itemscope).to receive(:id).and_return(nil)
    allow(org_itemscope).to receive(:properties).and_return(
      { 'name' => ['Acme Inc.'],
        'employee' => [student_itemscope]
      }
    )
    @item = Mida::Item.new(org_itemscope)
  end

  it 'should recognise an itemtype that is the child of that specified' do
    expect(@item.properties['employee'][0].vocabulary).to eq(Student)
    expect(@item.properties['employee'][0].type).to eq('http://example.com/vocab/student')
    expect(@item.properties['employee'][0].properties).to eq({
      'name' => 'Lorry Woodman',
      'tel' => ['000004847582'],
      'studying' => 'Classics'
    })
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

    tel_itemscope = double(Mida::Itemscope)
    allow(tel_itemscope).to receive(:kind_of?).with(Mida::Itemscope).and_return(true)
    allow(tel_itemscope).to receive(:type).and_return("http://example.com/vocab/tel")
    allow(tel_itemscope).to receive(:id).and_return(nil)
    allow(tel_itemscope).to receive(:properties).and_return(
      { 'dial_code' => ['0248583'],
        'number' => ['000004847582'],
      }
    )
    person_itemscope = double(Mida::Itemscope)
    allow(person_itemscope).to receive(:type).and_return("http://example.com/vocab/person")
    allow(person_itemscope).to receive(:id).and_return(nil)
    allow(person_itemscope).to receive(:properties).and_return(
      { 'name' => ['Lorry Woodman'],
        'tel' => ['000004847582', tel_itemscope],
      }
    )
    @item = Mida::Item.new(person_itemscope)
  end

  it 'should only accept values of the correct type' do
    expect(@item.properties['tel'].size).to eq(1)
    expect(@item.properties['tel'][0]).to eq('000004847582')
  end

end
