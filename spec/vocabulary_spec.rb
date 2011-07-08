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
    Organization.itemtype.should == %r{http://example\.com.*?organization$}i
  end

  it 'should specify name to appear once' do
    Organization.properties['name'][:num].should == :one
  end

  it 'should specify tel and url to appear many times' do
    Organization.properties['tel'][:num].should == :many
    Organization.properties['url'][:num].should == :many
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
    Review.itemtype.should == %r{http://example\.com.*?review$}i
  end

  it 'should specify itemreviewed to appear once' do
    Review.properties['itemreviewed'][:num].should == :one
  end

  it 'should specify that itemreviewed only have the type Mida::DataType::Text' do
    Review.properties['itemreviewed'][:types].should == [Mida::DataType::Text]
  end

  it 'should specify rating to appear once' do
    Review.properties['rating'][:num].should == :one
  end

  it 'should specify rating to only have the types: Rating, Mida::DataType::Text' do
    Review.properties['rating'][:types].should == [Rating, Mida::DataType::Text]
  end

  it 'should specify comments to appear many times' do
    Review.properties['comments'][:num].should == :many
  end

  it 'should specify that comments only have the type Comment' do
    Review.properties['comments'][:types].should == [Comment]
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
    Person.itemtype.should == %r{http://example.com/vocab/person}
  end

  it 'should specify that name only appears once' do
    Person.properties['name'][:num].should == :one
  end

  it 'should specify that any other property can appear many times' do
    Person.properties[:any][:num].should == :many
  end
  
  it 'should specify that any other property can have any type' do
    Person.properties[:any][:types].should == [:any]
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
    Mida::Vocabulary.vocabularies.should include(Person)
  end

  it '#included_vocabularies should be empty' do
    Person.included_vocabularies.empty?.should be_true
  end

end

describe Mida::Vocabulary, 'when subclassed and has no properties' do

  before do

    class Empty < Mida::Vocabulary
      itemtype %r{http://example.com/vocab/empty}
    end
  end

  it 'should register the vocabulary subclass' do
    Mida::Vocabulary.vocabularies.should include(Empty)
  end

  it '#properties should return an empty hash' do
    Mida::Vocabulary.properties.should == {}
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
    Car.itemtype.should == %r{http://example\.com.*?car$}i
  end

  it "should contain included vocabularies' properties" do
    ['description', 'make','model', 'colour'].each do
      |prop| Car.properties[prop][:num].should == :one
    end
    Car.properties['addons'][:num].should == :many
  end

  it "should contain new properties" do
    Car.properties['engine'][:num].should == :one
    Car.properties['stickers'][:num].should == :many
  end

  it '#included_vocabularies should return the included vocabularies' do
    [Thing, Product, Vehicle].each do |vocab|
      Car.included_vocabularies.should include(vocab)
    end
  end

  it '.kind_of? should still work with plain Vocabulary' do
    Car.kind_of?(Mida::Vocabulary).should be_true
  end

  it '.kind_of? should recognize included vocabularies' do
    Car.kind_of?(Car).should be_true
    Car.kind_of?(Vehicle).should be_true
    Vehicle.kind_of?(Product).should be_true
    Car.kind_of?(Product).should be_true
    Car.kind_of?(Thing).should be_true
  end

  it '.kind_of? should recognize vocabularies without a relationship' do
    Vehicle.kind_of?(Car).should be_false
    Thing.kind_of?(Product).should be_false
  end
end
