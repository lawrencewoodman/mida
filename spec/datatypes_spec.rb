require_relative '../lib/mida/datatypes'

describe Mida::DataTypes do

  it '#valid? should return true for type :text' do
    Mida::DataTypes.valid?(:text, "1").should be_true
  end

  it '#valid? should return true for an unknown type' do
    Mida::DataTypes.valid?(:unknown, "1").should be_false
  end

  it '#extract should return the input vale for type :text' do
    value = "A Test Value"
    Mida::DataTypes.extract(:text, value).should == value
  end

  it '#extract should return nil for an unknown type' do
    value = "A Test Value"
    Mida::DataTypes.extract(:unknown, value).should == nil
  end
end
