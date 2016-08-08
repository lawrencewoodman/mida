require 'mida/datatype'

describe Mida::DataType::Integer do

  it '#parse should raise an exception if not a number' do
    test = lambda {Mida::DataType::Integer.parse('hello')}
    expect(test).to raise_error(ArgumentError)
  end

  it '#parse should raise an exception if not an integer' do
    test = lambda {Mida::DataType::Integer.parse('3.14')}
    expect(test).to raise_error(ArgumentError)
  end

  it '#parse should raise an exception if value is empty' do
    test = lambda {Mida::DataType::Integer.parse('')}
    expect(test).to raise_error(ArgumentError)
  end

  it '#parse should accept a valid number' do
    integer_text = '3'
    integer = Mida::DataType::Integer.parse(integer_text)
    expect(integer.to_s).to eq(integer_text)
  end

end
