require File.dirname(__FILE__) + '/../test_helper'
require 'microdata/review'

describe Review, "when run against a full html document containing one itemscope" do

	before do
		html = "
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

		@review = Review.new.find(html)
	end

	it "should be able to return all the properties from the text" do
		expected_properties = [
			"itemreviewed",
			"reviewer",
			"dtreviewed",
			"summary",
			"description",
			"rating"
		]
		@review.properties.should == expected_properties
	end

	it "should create a method for each property and that should return the correct value" do
		@review.itemreviewed.should == "Romeo Pizza"
		@review.reviewer.should == "Ulysses Grant"
		@review.dtreviewed.should == "2009-01-06"
		@review.summary.should == "Delicious, tasty pizza in Eastlake!"
		@review.description.should == "Romeo serves up traditional wood-fired " \
		                             +"Neapolitan-style pizza, brought to your table " \
		                             +"promptly and without fuss. An ideal neighborhood " \
		                             +"pizza joint."
		@review.rating.should == 4.5
	end

end
