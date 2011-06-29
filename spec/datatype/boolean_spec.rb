require 'mida/datatype'

describe Mida::DataType::Boolean do

  it '#extract should raise an exception if some other text' do
    test = lambda {Mida::DataType::Boolean.extract('hello')}
    test.should raise_error(ArgumentError)
  end

  it '#extract should raise an exception if value is empty' do
    test = lambda {Mida::DataType::Boolean.extract('')}
    test.should raise_error(ArgumentError)
  end

  it '#extract should return true for "True" whatever the case' do
    ['true', 'True', 'TRUE', 'tRUE'].each do |true_text|
      Mida::DataType::Boolean.extract(true_text).should be_true
    end
  end

  it '#extract should return false for "False" whatever the case' do
    ['false', 'False', 'FALSE', 'fALSE'].each do |false_text|
      Mida::DataType::Boolean.extract(false_text).should be_false
    end
  end

end
