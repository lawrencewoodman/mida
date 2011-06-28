require_relative '../../lib/mida/datatype'

describe Mida::DataType::Float do

  it '#valid? should return true if a floating point number' do
    Mida::DataType::Float.valid?("3.14").should be_true
  end
  
  it '#valid? should return true if an integer' do
    Mida::DataType::Float.valid?("3").should be_true
  end
  
  it '#valid? should return false if not a number' do
    Mida::DataType::Float.valid?("a").should be_false
  end

  it '#valid? should return false if empty' do
    Mida::DataType::Float.valid?("").should be_false
  end

  it '#extract should return the input value as a floating point value' do
    value_string, value_float = "3.14", 3.14
    Mida::DataType::Float.extract(value_string).should == value_float
  end
end
