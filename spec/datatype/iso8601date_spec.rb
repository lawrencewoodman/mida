require 'mida/datatype'

describe Mida::DataType::ISO8601Date do

  it '#extract should raise an exception if some other text' do
    test = lambda {Mida::DataType::ISO8601Date.extract('27th Aug 2009')}
    test.should raise_error(ArgumentError)
  end

  it '#extract should raise an exception if value is empty' do
    test = lambda {Mida::DataType::ISO8601Date.extract('')}
    test.should raise_error(ArgumentError)
  end

  it '#extract? should return the input value' do
    date = "2009-08-27T01:13:04+05:10"
    Mida::DataType::ISO8601Date.extract(date).should == DateTime.parse(date)
    Mida::DataType::ISO8601Date.extract(date).to_s.should == date
  end
end
