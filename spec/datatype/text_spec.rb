require 'mida/datatype'

describe Mida::DataType::Text do

  it '#parse should accept an empty string' do
    text = Mida::DataType::Text.parse('')
    text.should == ''
  end

  it '#parse should return the input value' do
    test_text = 'Some text'
    text = Mida::DataType::Text.parse(test_text)
    text.should == test_text
  end

end
