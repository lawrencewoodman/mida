require 'mida/datatype'

describe Mida::DataType::Float do

  it '#extract should raise an exception if not a number' do
    test = lambda {Mida::DataType::Float.extract('hello')}
    test.should raise_error(ArgumentError)
  end

  it '#extract should raise an exception if value is empty' do
    test = lambda {Mida::DataType::Float.extract('')}
    test.should raise_error(ArgumentError)
  end

  it '#extract? should return the input value as a Float if a floating point' do
    Mida::DataType::Float.extract("3.14").should == 3.14
  end

  it '#extract? should return the input value as a Float if a integer' do
    Mida::DataType::Float.extract("3").should == 3
  end

end
