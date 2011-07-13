require 'mida/datatype'

describe Mida::DataType::Float do

  it '#parse should raise an exception if not a number' do
    test = lambda {Mida::DataType::Float.parse('hello')}
    test.should raise_error(ArgumentError)
  end

  it '#parse should raise an exception if value is empty' do
    test = lambda {Mida::DataType::Float.parse('')}
    test.should raise_error(ArgumentError)
  end

  it '#parse should accept a valid number' do
    float_text = '3.14'
    float = Mida::DataType::Float.parse(float_text)
    float.to_s.should == float_text
  end

end
