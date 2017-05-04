require 'mida/datatype'

describe Mida::DataType::Generic do

  class Number < Mida::DataType::Generic
    def initialize(value)
      @parsedValue = Float(value)  
    end
  end

  it '#parse should provide pass value straight to #new' do
    number = Number.parse('2.34')
    number == 2.34
  end

  it "should provide access to the underlying type's methods" do
    number = Number.new('2.34')
    expect(number.floor).to eq(2)
  end

  it '#to_s should use the underlying types #to_s method' do
    number = Number.parse('2.34')
    expect(number.to_s).to eq('2.34')
  end

  it '#to_yaml should provide a yaml representation of the items #to_s method' do
    number = Number.parse('2.34')
    expect(number.to_yaml).to match(/---\s+['"]2.34['"]\n/)
  end

  it '#== should match against underlying type, string representation and self' do
    number = Number.new('2.34')
    expect(number == 2.34).to be_truthy
    expect(number == '2.34').to be_truthy
    expect(number == number).to be_truthy

    expect(number == 2.44).to be_falsey
    expect(number == '2.44').to be_falsey
    expect(number == Number.new('2.44')).to be_falsey
  end

end
