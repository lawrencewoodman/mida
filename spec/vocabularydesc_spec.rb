require_relative 'spec_helper'
require_relative '../lib/mida'

describe Mida::VocabularyDesc, 'when subclassed and given has statements with no blocks' do
  before do
    class Organization < Mida::VocabularyDesc
      itemtype %r{http://example\.com.*?organization$}i
      has_one 'name'
      has_many 'tel', 'url'
    end
  end

  it '#itemtype should return the correct regexp' do
    Organization.itemtype.should == %r{http://example\.com.*?organization$}i
  end

  it 'should specify name to appear once' do
    Organization.prop_spec['name'][:num].should == :one
  end

  it 'should specify tel and url to appear many times' do
    Organization.prop_spec['tel'][:num].should == :many
    Organization.prop_spec['url'][:num].should == :many
  end
end

describe Mida::VocabularyDesc, 'when subclassed and given has statements with blocks' do
  before do
    class Rating < Mida::VocabularyDesc
      itemtype %r{http://example\.com.*?rating$}i
      has_one 'best', 'value'
    end

    class Comment < Mida::VocabularyDesc
      itemtype %r{http://example\.com.*?comment$}i
      has_one 'commentor', 'comment'
    end

    class Review < Mida::VocabularyDesc
      itemtype %r{http://example\.com.*?review$}i
      has_one 'itemreviewed'
      has_one 'rating' do
        extract Rating, :text
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
    Review.prop_spec['itemreviewed'][:num].should == :one
  end

  it 'should specify that itemreviewed only have the type :text' do
    Review.prop_spec['itemreviewed'][:types].should == [:text]
  end

  it 'should specify rating to appear once' do
    Review.prop_spec['rating'][:num].should == :one
  end

  it 'should specify rating to only have the types: Rating, :text' do
    Review.prop_spec['rating'][:types].should == [Rating, :text]
  end

  it 'should specify comments to appear many times' do
    Review.prop_spec['comments'][:num].should == :many
  end

  it 'should specify that comments only have the type Comment' do
    Review.prop_spec['comments'][:types].should == [Comment]
  end
end

describe Mida::VocabularyDesc, 'when subclassed and used with :any for properties and types' do
  before do
    class Person < Mida::VocabularyDesc
      itemtype %r{}
      has_one 'name'
      has_many :any do
        extract :any
      end
    end
  end

  it '#itemtype should return the correct regexp' do
    Person.itemtype.should == %r{}
  end

  it 'should specify that name only appears once' do
    Person.prop_spec['name'][:num].should == :one
  end

  it 'should specify that any other property can appear many times' do
    Person.prop_spec[:any][:num].should == :many
  end
  
  it 'should specify that any other property can have any type' do
    Person.prop_spec[:any][:types].should == [:any]
  end
end

describe Mida::VocabularyDesc, 'when subclassed' do

  before do
    # Make sure the class is redefined afresh to make sure that
    # inherited() hook is called
    Mida::Vocabulary.unregister(Person)
    Object.send(:remove_const, :Person)

    class Person < Mida::VocabularyDesc
      itemtype %r{}
      has_one 'name'
      has_many :any do
        extract :any
      end
    end
  end

  it 'should register the vocabulary subclass' do
    Mida::Vocabulary.vocabularies.should include(Person)
  end

end
