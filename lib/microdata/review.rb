require 'microdata'

class Review < Microdata

	def initialize
		@vocabulary = "http://data-vocabulary.org/Review"
		@properties = {
			'itemreviewed' => {:type => :inner_text},
			'places' => {:type => :inner_text},
			'reviewer' => {:type => :inner_text},
			'dtreviewed' => {:type => :datetime},
			'summary' => {:type => :inner_text},
			'description' => {:type => :inner_text},
			'rating' => {:type => :inner_float}
		}
	end

end
