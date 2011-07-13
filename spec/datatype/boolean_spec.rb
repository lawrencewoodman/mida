require 'mida/datatype'

describe Mida::DataType::Boolean do

  it '#parse should raise an exception if a invalid text passed' do
    test = lambda {Mida::DataType::Boolean.parse('example')}
    test.should raise_error(ArgumentError)
  end

  it '#parse should raise an exception if value is empty' do
    test = lambda {Mida::DataType::Boolean.parse('')}
    test.should raise_error(ArgumentError)
  end

  it '#parse should return true for "True" whatever the case' do
    ['true', 'True', 'TRUE', 'tRUE'].each do |true_text|
      Mida::DataType::Boolean.parse(true_text).should be_true
    end
  end

  it '#parse should return false for "False" whatever the case' do
    ['false', 'False', 'FALSE', 'fALSE'].each do |false_text|
      Mida::DataType::Boolean.parse(false_text).should be_false
    end
  end

  it '#to_s should return proper string representation of boolean' do
    Mida::DataType::Boolean.parse('fALSE').to_s.should == 'False'
    Mida::DataType::Boolean.parse('tRUE').to_s.should == 'True'
  end

  it '! should negate as if a TrueClass/FalseClass' do
    true_boolean = Mida::DataType::Boolean.parse('true')
    false_boolean = Mida::DataType::Boolean.parse('false')

    (!true_boolean).should be_false
    (!false_boolean).should be_true
  end

end
