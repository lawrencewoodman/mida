require 'mida/datatype'

describe Mida::DataType::Number do

  it '#parse should raise an exception if not a number' do
    test = lambda {Mida::DataType::Number.parse('hello')}
    test.should raise_error(ArgumentError)
  end

  it '#parse should raise an exception if value is empty' do
    test = lambda {Mida::DataType::Number.parse('')}
    test.should raise_error(ArgumentError)
  end

  it '#parse should accept a valid number' do
    num_text = '3.14'
    num = Mida::DataType::Number.parse(num_text)
    num.to_s.should == num_text
  end

end
