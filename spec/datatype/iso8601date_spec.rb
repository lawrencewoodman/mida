require 'mida/datatype'

describe Mida::DataType::ISO8601Date do

  it '#parse should raise an exception if invalid date format' do
    test = lambda {Mida::DataType::ISO8601Date.parse('27th August 2009')}
    expect(test).to raise_error(ArgumentError)
  end

  it '#parse should raise an exception if value is empty' do
    test = lambda {Mida::DataType::ISO8601Date.parse('')}
    expect(test).to raise_error(ArgumentError)
  end

  context 'when passed a valid date' do
    before do
      @date_text = "2009-08-27T01:13:04+05:10"
      @date = Mida::DataType::ISO8601Date.parse(@date_text)
    end

    it '#to_s should return the date as an rfc822 text string' do
      expect(@date.to_s).to eq("Thu, 27 Aug 2009 01:13:04 +0510")
    end

  end

end
