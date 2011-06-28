require_relative '../../lib/mida/datatype'

describe Mida::DataType::Integer do

  it '#valid? should return true for an integer' do
    Mida::DataType::Integer.valid?("1").should be_true
  end

  it '#valid? should return false for a floating point number' do
    Mida::DataType::Integer.valid?("3.14").should be_false
  end

  it '#valid? should return false if value is not a number' do
    Mida::DataType::Integer.valid?("hello").should be_false
  end

  it '#valid? should return false if value is empty' do
    Mida::DataType::Integer.valid?("").should be_false
  end

  it '#extract should return the input value as a floating point value' do
    value_string, value_integer = "3", 3
    Mida::DataType::Float.extract(value_string).should == value_integer
  end
end
