require 'mida/datatype'

describe Mida::DataType::Number do

  it '#valid? should return true if a floating point number' do
    Mida::DataType::Number.valid?("3.14").should be_true
  end
  
  it '#valid? should return true if an integer' do
    Mida::DataType::Number.valid?("3").should be_true
  end
  
  it '#valid? should return false if not a number' do
    Mida::DataType::Number.valid?("a").should be_false
  end

  it '#valid? should return false if empty' do
    Mida::DataType::Number.valid?("").should be_false
  end

  it '#extract should return the input value as a number' do
    value_string, value_num = "3.14", 3.14
    Mida::DataType::Number.extract(value_string).should == value_num
  end
end
