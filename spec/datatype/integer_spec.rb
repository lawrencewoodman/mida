require 'mida/datatype'

describe Mida::DataType::Integer do

  it '#extract should raise an exception if not a number' do
    test = lambda {Mida::DataType::Integer.extract('hello')}
    test.should raise_error(ArgumentError)
  end

  it '#extract should raise an exception if value is empty' do
    test = lambda {Mida::DataType::Integer.extract('')}
    test.should raise_error(ArgumentError)
  end

  it '#extract? should raise an exception if a floating point number' do
    test = lambda {Mida::DataType::Integer.extract('3.14')}
    test.should raise_error(ArgumentError)
  end

  it '#extract? should return the input value as a Integer if a integer' do
    Mida::DataType::Integer.extract("3").should == 3
  end
end
