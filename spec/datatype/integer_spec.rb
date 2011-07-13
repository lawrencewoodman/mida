require 'mida/datatype'

describe Mida::DataType::Integer do

  it '#parse should raise an exception if not a number' do
    test = lambda {Mida::DataType::Integer.parse('hello')}
    test.should raise_error(ArgumentError)
  end

  it '#parse should raise an exception if not an integer' do
    test = lambda {Mida::DataType::Integer.parse('3.14')}
    test.should raise_error(ArgumentError)
  end

  it '#parse should raise an exception if value is empty' do
    test = lambda {Mida::DataType::Integer.parse('')}
    test.should raise_error(ArgumentError)
  end

  it '#parse should accept a valid number' do
    integer_text = '3'
    integer = Mida::DataType::Integer.parse(integer_text)
    integer.to_s.should == integer_text
  end

end
