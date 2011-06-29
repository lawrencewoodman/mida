require 'mida/datatype'

describe Mida::DataType::Text do

  it '#extract should return an empty string if an empty string passed' do
    value = ''
    Mida::DataType::Text.extract(value).should == value
  end

  it '#extract should return the input value' do
    value = 'A Test Value'
    Mida::DataType::Text.extract(value).should == value
  end
end
