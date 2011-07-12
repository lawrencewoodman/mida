require 'mida/datatype'

describe Mida::DataType::URL do

  it '#extract should raise an exception if a bad url passed' do
    test = lambda {Mida::DataType::URL.extract('example.com')}
    test.should raise_error(ArgumentError)
  end

  it '#extract should raise an exception if value is empty' do
    test = lambda {Mida::DataType::URL.extract('')}
    test.should raise_error(ArgumentError)
  end

  it '#extract? should return the input value' do
    url = "http://example.com/test/"
    Mida::DataType::URL.extract(url).should == URI.parse(url)
    Mida::DataType::URL.extract(url).to_s.should == url
  end
end
