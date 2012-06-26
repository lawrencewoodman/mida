require 'spec_helper'
require 'mida'
require 'pathname'

describe Mida do
  it "should work with all fixtures" do
    url = "https://market.android.com/details?id=com.zeptolab.ctr.paid&hl=en"
    
    documents = Pathname.new(__FILE__).dirname.join('fixtures').children
    documents.each do |file|
      doc = Mida::Document.new(file.read, url)
      doc.items.should_not be_empty
    end 
  end
end