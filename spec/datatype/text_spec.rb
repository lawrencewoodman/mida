require 'mida/datatype'

describe Mida::DataType::Text do

  it '#valid? should return true for some text' do
    Mida::DataType::Text.valid?("1").should be_true
  end

  it '#valid? should return false if value is nil' do
    Mida::DataType::Text.valid?(nil).should be_false
  end

  it '#extract should return the input value' do
    value = "A Test Value"
    Mida::DataType::Text.extract(value).should == value
  end
end
