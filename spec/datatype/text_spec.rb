require 'mida/datatype'

describe Mida::DataType::Text do

  it '#parse should accept an empty string' do
    text = Mida::DataType::Text.parse('')
    expect(text).to eq('')
  end

  it '#parse should return the input value' do
    test_text = 'Some text'
    text = Mida::DataType::Text.parse(test_text)
    expect(text).to eq(test_text)
  end

end
