require 'mida/datatype'

describe Mida::DataType::Number do

  it '#extract should raise an exception if not a number' do
    test = lambda {Mida::DataType::Number.extract('hello')}
    test.should raise_error(ArgumentError)
  end

  it '#extract should raise an exception if value is empty' do
    test = lambda {Mida::DataType::Number.extract('')}
    test.should raise_error(ArgumentError)
  end

  it '#extract? should return the input value as a number if a floating point' do
    Mida::DataType::Number.extract("3.14").should == 3.14
  end

  it '#extract? should return the input value as a number if a integer' do
    Mida::DataType::Number.extract("3").should == 3
  end

end
