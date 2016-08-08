require 'spec_helper'
require 'mida/propertydesc'

describe Mida::PropertyDesc, 'when initialized without a block' do
  before do
    @propertyDesc = Mida::PropertyDesc.new(3)
  end

  it '#to_h[:num] should equal num passed' do
    expect(@propertyDesc.to_h[:num]).to eq(3)
  end

  it '#to_h[:types] should equal DataType::Text' do
    expect(@propertyDesc.to_h[:types]).to eq([Mida::DataType::Text])
  end
end

describe Mida::PropertyDesc, 'when initialized with a block with no specified types' do
  before do
    @propertyDesc = Mida::PropertyDesc.new(3) {}
  end

  it '#to_h[:types] should equal DataType::Text' do
    expect(@propertyDesc.to_h[:types]).to eq([Mida::DataType::Text])
  end
end

describe Mida::PropertyDesc, 'when initialized with a block that specifies types with extract()' do
  before do
    @propertyDesc = Mida::PropertyDesc.new(3) { extract String, Array}
  end

  it '#to_h[:types] should equal [String, Array]' do
    expect(@propertyDesc.to_h[:types]).to eq([String, Array])
  end
end

describe Mida::PropertyDesc, 'when initialized with a block that specifies types with types()' do
  before do
    @propertyDesc = nil
    @error = last_stderr do
      @propertyDesc = Mida::PropertyDesc.new(3) { types String, Array}
    end
  end

  it 'should warn on initialization if types() is used in the block' do
    expect(@error).to eq("[DEPRECATION] Mida::PropertyDesc#types is deprecated.  "+
      "Please use Mida::PropertyDesc#extract instead."
    )
  end

  it '#to_h[:types] should equal [String, Array]' do
    expect(@propertyDesc.to_h[:types]).to eq([String, Array])
  end

end
