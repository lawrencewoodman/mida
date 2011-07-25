require 'mida/datatype'
require 'mida/datatype/url'

describe Mida::DataType::Enumeration do
  before :all do
    class BookType < Mida::DataType::Enumeration
      VALID_VALUES = [
        [::Mida::DataType::URL, %r{http://example.com/ebook}i],
        [::Mida::DataType::URL, %r{http://example.com/paperback}i]
      ]
    end
  end

  it '#parse should raise an exception if an invalid url passed' do
    test = lambda {BookType.parse('http://example.com/hardback')}
    test.should raise_error(ArgumentError)
  end

  it '#parse should raise an exception if value is empty' do
    test = lambda {BookType.parse('')}
    test.should raise_error(ArgumentError)
  end

  it '#parse should accept a valid value' do
    url_text = 'http://example.com/ebook'
    url = BookType.parse(url_text)
    url.to_s.should == url_text
  end

end
