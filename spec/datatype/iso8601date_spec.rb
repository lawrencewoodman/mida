require_relative '../../lib/mida/datatype'

describe Mida::DataType::ISO8601Date do
  it '#valid? should return true if a valid iso8601 date has been passed' do
    Mida::DataType::ISO8601Date.valid?("2009-08-27T01:13:04+05:10").should be_true
  end

  it '#valid? should return false if not a valid iso8601 date has been passed' do
    Mida::DataType::ISO8601Date.valid?("27th August 2009").should be_false
  end

  it '#extract? should return the input value' do
    date = "2009-08-27T01:13:04+05:10"
    Mida::DataType::ISO8601Date.extract(date).should == DateTime.parse(date)
    Mida::DataType::ISO8601Date.extract(date).to_s.should == date
  end
end
