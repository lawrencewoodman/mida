require_relative '../../lib/mida/datatype'

describe Mida::DataType::Boolean do

  it '#valid? should return true for "True" whatever the case' do
    ['true', 'True', 'TRUE', 'tRUE'].each do |true_text|
      Mida::DataType::Boolean.valid?(true_text).should be_true
    end
  end

  it '#valid? should return true for "False" whatever the case' do
    ['false', 'False', 'FALSE', 'fALSE'].each do |false_text|
      Mida::DataType::Boolean.valid?(false_text).should be_true
    end
  end

  it '#valid? should return false if some other text' do
    Mida::DataType::Boolean.valid?("hello").should be_false
  end

  it '#valid? should return false if value is empty' do
    Mida::DataType::Boolean.valid?("").should be_false
  end

  it '#extract? should return true for "True" whatever the case' do
    ['true', 'True', 'TRUE', 'tRUE'].each do |true_text|
      Mida::DataType::Boolean.valid?(true_text).should be_true
    end
  end

  it '#extract should return false for "False" whatever the case' do
    ['false', 'False', 'FALSE', 'fALSE'].each do |false_text|
      Mida::DataType::Boolean.extract(false_text).should be_false
    end
  end

end
