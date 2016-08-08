require 'spec_helper'
require 'mida'

describe Mida::Vocabulary, 'when subclassed and given has statements with no blocks' do
  before do
    class Organization < Mida::Vocabulary
      itemtype %r{http://example\.com.*?organization$}i
      has_one 'name'
      has_many 'tel', 'url'
    end
  end

  it '#itemtype should return the correct regexp' do
    expect(Organization.itemtype).to eq(%r{http://example\.com.*?organization$}i)
  end

  it 'should specify name to appear once' do
    expect(Organization.properties['name'][:num]).to eq(:one)
  end

  it 'should specify tel and url to appear many times' do
    expect(Organization.properties['tel'][:num]).to eq(:many)
    expect(Organization.properties['url'][:num]).to eq(:many)
  end
end

describe Mida::Vocabulary, 'when subclassed and given has statements with blocks' do
  before do
    class Rating < Mida::Vocabulary
      itemtype %r{http://example\.com.*?rating$}i
      has_one 'best', 'value'
    end

    class Comment < Mida::Vocabulary
      itemtype %r{http://example\.com.*?comment$}i
      has_one 'commentor', 'comment'
    end

    class Review < Mida::Vocabulary
      itemtype %r{http://example\.com.*?review$}i
      has_one 'itemreviewed'
      has_one 'rating' do
        extract Rating, Mida::DataType::Text
      end
      has_many 'comments' do
        extract Comment
      end
    end
  end

  it '#itemtype should return the correct regexp' do
    expect(Review.itemtype).to eq(%r{http://example\.com.*?review$}i)
  end

  it 'should specify itemreviewed to appear once' do
    expect(Review.properties['itemreviewed'][:num]).to eq(:one)
  end

  it 'should specify that itemreviewed only have the type Mida::DataType::Text' do
    expect(Review.properties['itemreviewed'][:types]).to eq([Mida::DataType::Text])
  end

  it 'should specify rating to appear once' do
    expect(Review.properties['rating'][:num]).to eq(:one)
  end

  it 'should specify rating to only have the types: Rating, Mida::DataType::Text' do
    expect(Review.properties['rating'][:types]).to eq([Rating, Mida::DataType::Text])
  end

  it 'should specify comments to appear many times' do
    expect(Review.properties['comments'][:num]).to eq(:many)
  end

  it 'should specify that comments only have the type Comment' do
    expect(Review.properties['comments'][:types]).to eq([Comment])
  end
end

describe Mida::Vocabulary, 'when subclassed and used with :any for properties and types' do
  before do
    class Person < Mida::Vocabulary
      itemtype %r{http://example.com/vocab/person}
      has_one 'name'
      has_many :any do
        extract :any
      end
    end
  end

  it '#itemtype should return the correct regexp' do
    expect(Person.itemtype).to eq(%r{http://example.com/vocab/person})
  end

  it 'should specify that name only appears once' do
    expect(Person.properties['name'][:num]).to eq(:one)
  end

  it 'should specify that any other property can appear many times' do
    expect(Person.properties[:any][:num]).to eq(:many)
  end
  
  it 'should specify that any other property can have any type' do
    expect(Person.properties[:any][:types]).to eq([:any])
  end
end

describe Mida::Vocabulary, 'when subclassed' do

  before do
    # Make sure the class is redefined afresh to make sure that
    # inherited() hook is called
    Mida::Vocabulary.unregister(Person)
    Object.send(:remove_const, :Person)

    class Person < Mida::Vocabulary
      itemtype %r{http://example.com/vocab/person}
      has_one 'name'
      has_many :any do
        extract :any
      end
    end
  end

  it 'should register the vocabulary subclass' do
    expect(Mida::Vocabulary.vocabularies).to include(Person)
  end

  it '#included_vocabularies should be empty' do
    expect(Person.included_vocabularies.empty?).to be_truthy
  end

end

describe Mida::Vocabulary, 'when subclassed and has no properties' do

  before do

    class Empty < Mida::Vocabulary
      itemtype %r{http://example.com/vocab/empty}
    end
  end

  it 'should register the vocabulary subclass' do
    expect(Mida::Vocabulary.vocabularies).to include(Empty)
  end

  it '#properties should return an empty hash' do
    expect(Mida::Vocabulary.properties).to eq({})
  end

end

describe Mida::Vocabulary, 'when subclassed and using #include_vocabulary' do
  before do
    class Thing < Mida::Vocabulary
      itemtype %r{http://example\.com.*?thing$}i
      has_one 'description'
    end

    class Product < Mida::Vocabulary
      include_vocabulary Thing
      itemtype %r{http://example\.com.*?product$}i
      has_one 'make', 'model'
      has_many 'addons'
    end

    class Vehicle < Mida::Vocabulary
      itemtype %r{http://example\.com.*?thing$}i
      include_vocabulary Product
      has_one 'colour'
    end

    class Car < Mida::Vocabulary
      include_vocabulary Product, Vehicle
      itemtype %r{http://example\.com.*?car$}i
      has_one 'engine'
      has_many 'stickers'
    end
  end

  it '#itemtype should return the new regexp' do
    expect(Car.itemtype).to eq(%r{http://example\.com.*?car$}i)
  end

  it "should contain included vocabularies' properties" do
    ['description', 'make','model', 'colour'].each do
      |prop| expect(Car.properties[prop][:num]).to eq(:one)
    end
    expect(Car.properties['addons'][:num]).to eq(:many)
  end

  it "should contain new properties" do
    expect(Car.properties['engine'][:num]).to eq(:one)
    expect(Car.properties['stickers'][:num]).to eq(:many)
  end

  it '#included_vocabularies should return the included vocabularies' do
    [Thing, Product, Vehicle].each do |vocab|
      expect(Car.included_vocabularies).to include(vocab)
    end
  end

  it '.kind_of? should still work with plain Vocabulary' do
    expect(Car.kind_of?(Mida::Vocabulary)).to be_truthy
  end

  it '.kind_of? should recognize included vocabularies' do
    expect(Car.kind_of?(Car)).to be_truthy
    expect(Car.kind_of?(Vehicle)).to be_truthy
    expect(Vehicle.kind_of?(Product)).to be_truthy
    expect(Car.kind_of?(Product)).to be_truthy
    expect(Car.kind_of?(Thing)).to be_truthy
  end

  it '.kind_of? should recognize vocabularies without a relationship' do
    expect(Vehicle.kind_of?(Car)).to be_falsey
    expect(Thing.kind_of?(Product)).to be_falsey
  end
end

describe Mida::Vocabulary, 'when subclassed with circular dependancies' do
  before do
    # Dummy classes to allow forward references
    class Medicine < Mida::Vocabulary; end
    class Potion < Mida::Vocabulary; end

    class Medicine < Mida::Vocabulary
      itemtype %r{http://example\.com.*?medicine$}i
      include_vocabulary Potion
      has_one 'type'
      has_one 'creator'

      has_many 'derived_from' do
        extract Medicine
      end

      has_many 'alternatives' do
        extract Potion
      end
    end

    class Potion < Mida::Vocabulary
      include_vocabulary Medicine
      itemtype %r{http://example\.com.*?potion$}i
      has_many 'cures'

      has_many 'use_with' do
        extract Medicine
      end

      has_many 'similar_to' do
        extract Potion
      end
    end
  end

  it "both classes should have its own and included properties" do
    expected_properties = {
      'type' => {types: [Mida::DataType::Text], num: :one},
      'creator' => {types: [Mida::DataType::Text], num: :one},
      'derived_from' => {types: [Medicine], num: :many},
      'alternatives' => {types: [Potion], num: :many},
      'cures' => {types: [Mida::DataType::Text], num: :many},
      'use_with' => {types: [Medicine], num: :many},
      'similar_to' => {types: [Potion], num: :many}
    }
    expect(Medicine.properties).to eq(expected_properties)
    expect(Potion.properties).to eq(expected_properties)
  end
end
