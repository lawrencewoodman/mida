require 'mida/datatype'

describe Mida::DataType::Generic do

  before do
    class Number < Mida::DataType::Generic
      def initialize(value)
        @parsedValue = Float(value)  
      end
    end
  end

  it '#parse should provide pass value straight to #new' do
    number = Number.parse('2.34')
    number == 2.34
  end

  it "should provide access to the underlying type's methods" do
    number = Number.new('2.34')
    number.floor.should == 2
  end

  it '#to_s should use the underlying types #to_s method' do
    number = Number.parse('2.34')
    number.to_s.should == '2.34'
  end

  it '#to_yaml should provide a yaml representation of the items #to_s method' do
    number = Number.parse('2.34')
    number.to_yaml.should =~ /---\s+"2.34"\n/
  end

  it '#== should match against underlying type, string representation and self' do
    number = Number.new('2.34')
    (number == 2.34).should be_true
    (number == '2.34').should be_true
    (number == number).should be_true

    (number == 2.44).should be_false
    (number == '2.44').should be_false
    (number == Number.new('2.44')).should be_false
  end

end
