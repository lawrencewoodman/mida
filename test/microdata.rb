require File.dirname(__FILE__) + '/test_helper'
require 'microdata'

describe Microdata, "when run against a full html document containing one itemscope with no itemtype" do

	before do
		@html = "
			<html>
				<head>
				</head>
				<body>
					There is some text here
					<div>
						and also some here
						<div itemscope>
							<span itemprop=\"itemreviewed\">Romeo Pizza</span>
							Reviewed by <span itemprop=\"reviewer\">Ulysses Grant</span> on
							<time itemprop=\"dtreviewed\" datetime=\"2009-01-06\">Jan 6</time>.
							<span itemprop=\"summary\">Delicious, tasty pizza in Eastlake!</span>
							<span itemprop=\"description\">Romeo serves up traditional wood-fired Neapolitan-style pizza, " \
								+"brought to your table promptly and without fuss. An ideal neighborhood pizza joint.</span>
							Rating: <span itemprop=\"rating\">4.5</span>
						</div>
					</div>
				</body>
			</html>
		"

	end

	it "shouldn't match itemscopes with different names" do
		Microdata.find(@html, "nothing").should == nil
	end

	it "shouldn't match itemscopes with no names, or none specifed" do
		Microdata.find(@html, "").should_not == nil
		Microdata.find(@html).should_not == nil
	end

	it "should specify the correct type" do
		Microdata.find(@html, "").type.should == ""
		Microdata.find(@html).type.should == ""
	end

	it "should return all the properties from the text" do
		expected_properties = [
			"itemreviewed",
			"reviewer",
			"dtreviewed",
			"summary",
			"description",
			"rating"
		]
		md = Microdata.find(@html, "")
		md.properties.should == expected_properties

		md = Microdata.find(@html)
		md.properties.should == expected_properties
	end

	it "should create method for each property and that should return the correct value" do
		md = Microdata.find(@html)
		md.itemreviewed.should == "Romeo Pizza"
		md.reviewer.should == "Ulysses Grant"
		md.dtreviewed.should == "2009-01-06"
		md.summary.should == "Delicious, tasty pizza in Eastlake!"
		md.description.should == "Romeo serves up traditional wood-fired " \
		                         +"Neapolitan-style pizza, brought to your table " \
		                         +"promptly and without fuss. An ideal neighborhood " \
		                         +"pizza joint."
		md.rating.should == "4.5"
	end

end

describe Microdata, "when run against a full html document containing one itemscope with an itemtype" do

	before do
		@html = "
			<html>
				<head>
				</head>
				<body>
					There is some text here
					<div>
						and also some here
						<div itemscope itemtype=\"http://data-vocabulary.org/Review\">
							<span itemprop=\"itemreviewed\">Romeo Pizza</span>
							Reviewed by <span itemprop=\"reviewer\">Ulysses Grant</span> on
							<time itemprop=\"dtreviewed\" datetime=\"2009-01-06\">Jan 6</time>.
							<span itemprop=\"summary\">Delicious, tasty pizza in Eastlake!</span>
							<span itemprop=\"description\">Romeo serves up traditional wood-fired Neapolitan-style pizza, " \
								+"brought to your table promptly and without fuss. An ideal neighborhood pizza joint.</span>
							Rating: <span itemprop=\"rating\">4.5</span>
						</div>
					</div>
				</body>
			</html>
		"

	end

	it "shouldn't match itemscopes with different names" do
		Microdata.find(@html, "nothing").should == nil
	end

	it "should specify the correct type" do
		Microdata.find(@html, "Review").type.should == "Review"
		Microdata.find(@html).type.should == "Review"
	end

	it "should return all the properties from the text" do
		md = Microdata.find(@html, "Review")
		expected_properties = [
			"itemreviewed",
			"reviewer",
			"dtreviewed",
			"summary",
			"description",
			"rating"
		]
		md.properties.should == expected_properties
	end

	it "should create method for each property and that should return the correct value" do
		md = Microdata.find(@html, "Review")
		md.itemreviewed.should == "Romeo Pizza"
		md.reviewer.should == "Ulysses Grant"
		md.dtreviewed.should == "2009-01-06"
		md.summary.should == "Delicious, tasty pizza in Eastlake!"
		md.description.should == "Romeo serves up traditional wood-fired " \
		                         +"Neapolitan-style pizza, brought to your table " \
		                         +"promptly and without fuss. An ideal neighborhood " \
		                         +"pizza joint."
		md.rating.should == "4.5"
	end

end

describe Microdata, "when run against a full html document containing two itemscopes with itemtypes" do

	before do
		@html = "
			<html>
				<head>
				</head>
				<body>
					There is some text here
					<div>
						and also some here
						<div itemscope itemtype=\"http://data-vocabulary.org/Review\">
							<span itemprop=\"itemreviewed\">Romeo Pizza</span>
							Rating: <span itemprop=\"rating\">4.5</span>
						</div>
						<div itemscope itemtype=\"http://data-vocabulary.org/Organization\">
							<span itemprop=\"name\">IBM</span>
							<span itemprop=\"url\">http://ibm.com</span>
						</div>
					</div>
				</body>
			</html>
		"

	end

	it "should return all the itemscopes if none specified" do
		md = Microdata.find(@html)
		md.size.should == 2
	end

	it "should give the type of each itemscope if none specified" do
		itemscope_names = {"Review" => 0, "Organization" => 0}

		Microdata.find(@html).each do |md|
			itemscope_names[md.type] += 1
		end

		itemscope_names.each { |name, num| num.should == 1 }
	end

	it "should give the type of each itemscope if specified" do
		["Review", "Organization"].each do |name|
			Microdata.find(@html, name).type.should == name
		end
	end

	it "should return all the properties from the text for 1st itemscope" do
		md = Microdata.find(@html, "Review")
		expected_properties = [
			"itemreviewed",
			"rating"
		]
		md.properties.should == expected_properties
	end

	it "should return all the properties from the text for 2nd itemscope" do
		md = Microdata.find(@html, "Organization")
		expected_properties = [
			"name",
			"url"
		]
		md.properties.should == expected_properties
	end

	it "should create a method for each property and that should return the correct value" do
		md = Microdata.find(@html, "Review")
		md.itemreviewed.should == "Romeo Pizza"
		md.rating.should == "4.5"

		md = Microdata.find(@html, "Organization")
		md.name.should == "IBM"
		md.url.should == "http://ibm.com"
	end

end
