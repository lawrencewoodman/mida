require_relative 'test_helper'
require 'microdata'

shared_examples_for 'one root itemscope' do
	it 'should not match itemscopes with different names' do
		@md.find('nothing').should == nil
	end

	it 'should match any itemscope if no vocabulary specified' do
		@md.find().should_not == nil
	end

	it 'should find the correct number of itemscopes' do
		@md.find().size.should == 1
	end
end

describe Microdata, 'when run against a full html document containing one itemscope with no itemtype' do

	before do
		html = '
			<html><body>
				There is some text here
				<div>
					and also some here
					<div itemscope>
						<span itemprop="itemreviewed">Romeo Pizza</span>
						Reviewed by <span itemprop="reviewer">Ulysses Grant</span> on
						<time itemprop="dtreviewed" datetime="2009-01-06">Jan 6</time>.
						<span itemprop="summary">Delicious, tasty pizza in Eastlake!</span>
						<span itemprop="description">Romeo serves up traditional wood-fired Neapolitan-style pizza, ' \
							+'brought to your table promptly and without fuss. An ideal neighborhood pizza joint.</span>
						Rating: <span itemprop="rating">4.5</span>
					</div>
				</div>
			</body></html>
		'
		@md = Microdata.new(html)

	end

	it_should_behave_like 'one root itemscope'

	it 'should return all the properties and types with the correct values' do
		expected_result = {
			type: nil,
			properties: {
				'itemreviewed' => 'Romeo Pizza',
				'reviewer' => 'Ulysses Grant',
				'dtreviewed' => '2009-01-06',
				'summary' => 'Delicious, tasty pizza in Eastlake!',
				'description' => 'Romeo serves up traditional wood-fired ' \
												+'Neapolitan-style pizza, brought to your table ' \
												+'promptly and without fuss. An ideal neighborhood ' \
												+'pizza joint.',
				'rating' => '4.5'
			}
		}

		@md.find().first.should == expected_result
	end

end

describe Microdata, 'when run against a full html document containing one itemscope nested within another' do

	before do
		html = '
			<html><body>
				There is some text here
				<div>
					and also some here
					<div itemscope>
						<span itemprop="itemreviewed">Romeo Pizza</span>
						<div itemprop="address" itemscope>
							<span itemprop="firstline">237 Italian Way</span>
							<span itemprop="country">United Kingdom</span>
						</div>
						Rating: <span itemprop="rating">4.5</span>
					</div>
				</div>
			</body></html>
		'

		@md = Microdata.new(html)

	end

	it_should_behave_like 'one root itemscope'

	it 'should return all the properties and types with the correct values' do
		expected_result = {
			type: nil,
			properties: {
				'itemreviewed' => 'Romeo Pizza',
				'address' => { type: nil, properties: {'firstline' => '237 Italian Way', 'country' => 'United Kingdom' } },
				'rating' => '4.5'
			}
		}

		@md.find().first.should == expected_result
	end

end

describe Microdata, 'when run against a full html document containing one itemscope nested within another within another' do

	before do
		html = '
			<html><body>
				There is some text here
				<div>
					and also some here
					<div itemscope>
						<span itemprop="itemreviewed">Romeo Pizza</span>
						<div itemprop="address" itemscope>
							<div itemprop="firstline" itemscope>
								<span itemprop="number">237</span>
								<span itemprop="road">Italian Way</span>
							</div>
							<span itemprop="country">United Kingdom</span>
						</div>
						Rating: <span itemprop="rating">4.5</span>
					</div>
				</div>
			</body></html>
		'

		@md = Microdata.new(html)
	end

	it_should_behave_like 'one root itemscope'

	it 'should return all the properties and types with the correct values' do
		expected_result = {
			type: nil,
			properties: {
				'itemreviewed' => 'Romeo Pizza',
				'address' => {
					type: nil,
					properties: {
						'firstline' => {
							type: nil,
							properties: {
								'number' => '237',
								'road' => 'Italian Way'
							},
						},
						'country' => 'United Kingdom'
					},
				},
				'rating' => '4.5'
			}
		}

		@md.find().first.should == expected_result
	end

end

describe Microdata, 'when run against a full html document containing one itemscope with an itemtype' do

	before do
		html = '
			<html><body>
				There is some text here
				<div>
					and also some here
					<div itemscope itemtype="http://data-vocabulary.org/Review">
						<span itemprop="itemreviewed">Romeo Pizza</span>
						Reviewed by <span itemprop="reviewer">Ulysses Grant</span> on
						<time itemprop="dtreviewed" datetime="2009-01-06">Jan 6</time>.
						<span itemprop="summary">Delicious, tasty pizza in Eastlake!</span>
						<span itemprop="description">Romeo serves up traditional wood-fired Neapolitan-style pizza, ' \
							+'brought to your table promptly and without fuss. An ideal neighborhood pizza joint.</span>
						Rating: <span itemprop="rating">4.5</span>
					</div>
				</div>
			</body></html>
		'

		@md = Microdata.new(html)

	end

	it_should_behave_like 'one root itemscope'

	it 'should find the correct number of itemscopes if outer specified' do
		@md.find('http://data-vocabulary.org/Review').size.should == 1
	end

	it 'should specify the correct type' do
		vocabularies = [
			nil,
			'http://data-vocabulary.org/Review'
		]
		vocabularies.each do |vocabulary|
			@md.find(vocabulary).first[:type].should == 'http://data-vocabulary.org/Review'
		end
	end

	it 'should return all the properties and types with the correct values' do
		expected_result = {
			type: 'http://data-vocabulary.org/Review',
			properties: {
				'itemreviewed' => 'Romeo Pizza',
				'reviewer' => 'Ulysses Grant',
				'dtreviewed' => '2009-01-06',
				'summary' => 'Delicious, tasty pizza in Eastlake!',
				'description'  => 'Romeo serves up traditional wood-fired ' \
												 +'Neapolitan-style pizza, brought to your table ' \
												 +'promptly and without fuss. An ideal neighborhood ' \
												 +'pizza joint.',
				'rating' => '4.5'
			}
		}
		@md.find().first.should == expected_result
	end

end

describe Microdata, 'when run against a full html document containing two non-nested itemscopes with itemtypes' do

	before do
		html = '
			<html><body>
				There is some text here
				<div>
					and also some here
					<div itemscope itemtype="http://data-vocabulary.org/Review">
						<span itemprop="itemreviewed">Romeo Pizza</span>
						Rating: <span itemprop="rating">4.5</span>
					</div>
					<div itemscope itemtype="http://data-vocabulary.org/Organization">
						<span itemprop="name">IBM</span>
						<span itemprop="url">http://ibm.com</span>
					</div>
				</div>
			</body></html>
		'

		@md = Microdata.new(html)

	end

	it 'should return all the itemscopes if none specified' do
		@md.find().size.should == 2
	end

	it 'should give the type of each itemscope if none specified' do
		itemscope_names = {
			'http://data-vocabulary.org/Review' => 0,
			'http://data-vocabulary.org/Organization' => 0
		}

		@md.find().each do |itemscope|
			itemscope_names[itemscope[:type]] += 1
		end

		itemscope_names.size.should == 2
		itemscope_names.each { |name, num| num.should == 1 }
	end


	it 'should return all the properties and types with the correct values for 1st itemscope' do
		expected_result = {
			type: 'http://data-vocabulary.org/Review',
			properties: {
				'itemreviewed' => 'Romeo Pizza',
				'rating' => '4.5'
			}
		}
		properties = @md.find('http://data-vocabulary.org/Review').first
		properties.should == expected_result
	end

	it 'should return all the properties from the text for 2nd itemscope' do
		expected_result = {
			type: 'http://data-vocabulary.org/Organization',
			properties: {
				'name' => 'IBM',
				'url' => 'http://ibm.com'
			}
		}
		properties = @md.find('http://data-vocabulary.org/Organization').first
		properties.should == expected_result
	end

end

describe Microdata, 'when run against a full html document containing one
	itemscope nested within another and the inner block is
	surrounded with another non itemscope block' do

	before do
		html = '
			<html><body>
				<div itemscope itemtype="http://data-vocabulary.org/Product">
					<ul class="reviews">
						<li id="model" itemprop="name">DC07</li>
						<li id="make" itemprop="brand">Dyson</li>
						<li itemprop="review" itemscope itemtype="http://data-vocabulary.org/Review-aggregate">
							<span class="ratingDetails">
								<span itemprop="count">1</span> Review,
								Average: <span itemprop="rating">5.0</span>
							</span>
						</li>
					</ul>
				</div>
			</body></html>
		'

		@md = Microdata.new(html)
	end

	it_should_behave_like 'one root itemscope'

	it 'should return the correct number of itemscopes' do
		vocabularies = [
			nil,
			'http://data-vocabulary.org/Product',
			'http://data-vocabulary.org/Review-aggregate'
		]
		vocabularies.each {|vocabulary| @md.find(vocabulary).size.should == 1}
	end

	context "when no vocabulary specified or looking at the outer vocabulary" do
		it 'should return all the properties from the text with the correct values' do
			expected_result = {
				type: 'http://data-vocabulary.org/Product',
				properties: {
					'name' => 'DC07',
					'brand' => 'Dyson',
					'review' => {
						type: 'http://data-vocabulary.org/Review-aggregate',
						properties: {
							'count' => '1',
							'rating' => '5.0'
						}
					}
				}
			}

			vocabularies = [
				nil,
				'http://data-vocabulary.org/Product',
			]
			vocabularies.each do |vocabulary|
				@md.find(vocabulary).first.should == expected_result
			end
		end
	end

end
