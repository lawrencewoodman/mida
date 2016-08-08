#encoding: utf-8
#
require 'mida/datatype'
require 'yaml'

describe Mida::DataType::URL do

  it '#parse should raise an exception if a bad url passed' do
    test = lambda {Mida::DataType::URL.parse('example.com')}
    expect(test).to raise_error(ArgumentError)
  end

  it '#parse should raise an exception if value is empty' do
    test = lambda {Mida::DataType::URL.parse('')}
    expect(test).to raise_error(ArgumentError)
  end

  it '#parse should accept a valid url' do
    url_text = 'http://example.com/test/'
    url = Mida::DataType::URL.parse(url_text)
    expect(url.to_s).to eq(url_text)
  end

  it '#parse should accept a valid url with special characters' do
    url_text = 'http://example.com/übergangslösung'
    url = Mida::DataType::URL.parse(url_text)
    expect(url.to_s).to eq(::Addressable::URI.encode(url_text))
  end
end
