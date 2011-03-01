require_relative 'test_helper'
require 'microdata'

describe Microdata, 'when run against a full html document containing one itemscope with no itemtype' do

	before do
		html = '
			<html>
				<head>
				</head>
				<body>
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
				</body>
			</html>
		'
		@md = Microdata.new(html)

	end

	it 'should not match itemscopes with different names' do
		@md.find('nothing').should == nil
	end

	it 'should not match itemscopes with no names, or none specifed' do
		@md.find().should_not == nil
	end

	it 'should find the correct number of itemscopes' do
		@md.find().size.should == 1
	end

	it 'should specify the correct type' do
		@md.find().first[:type].should == nil
	end

	it 'should return all the properties from the text with the correct values' do
		expected_properties = {
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

		@md.find().first[:properties].should == expected_properties
	end

end

describe Microdata, 'when run against a full html document containing one itemscope nested within another' do

	before do
		html = '
			<html>
				<head>
				</head>
				<body>
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
				</body>
			</html>
		'

		@md = Microdata.new(html)

	end

	it 'should not match itemscopes with different names' do
		@md.find('nothing').should == nil
	end

	it 'should match itemscopes with no names, or none specifed' do
		@md.find().should_not == nil
	end

	it 'should find the correct number of itemscopes' do
		@md.find().size.should == 1
	end

	it 'should specify the correct type' do
		@md.find().first[:type].should == nil
	end

	it 'should return all the properties from the text with the correct values' do
		expected_properties = {
			'itemreviewed' => 'Romeo Pizza',
			'address' => { type: nil, properties: {'firstline' => '237 Italian Way', 'country' => 'United Kingdom' } },
			'rating' => '4.5'
		}

		@md.find().first[:properties].should == expected_properties
	end

end

describe Microdata, 'when run against a full html document containing one itemscope nested within another within another' do

	before do
		html = '
			<html>
				<head>
				</head>
				<body>
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
				</body>
			</html>
		'

		@md = Microdata.new(html)
	end

	it 'should not match itemscopes with different names' do
		@md.find('nothing').should == nil
	end

	it 'should match itemscopes with no names, or none specifed' do
		@md.find().should_not == nil
	end

	it 'should find the correct number of itemscopes' do
		@md.find().size.should == 1
	end

	it 'should specify the correct type' do
		@md.find().first[:type].should == nil
	end

	it 'should return all the properties from the text with the correct values' do
		expected_properties = {
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

		@md.find().first[:properties].should == expected_properties
	end

end

describe Microdata, 'when run against a full html document containing one itemscope with an itemtype' do

	before do
		html = '
			<html>
				<head>
				</head>
				<body>
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
				</body>
			</html>
		'

		@md = Microdata.new(html)

	end

	it 'should not match itemscopes with different names' do
		@md.find('nothing').should == nil
	end

	it 'should find the correct number of itemscopes' do
		@md.find().size.should eq 1
		@md.find('http://data-vocabulary.org/Review').size.should == 1
	end

	it 'should specify the correct type' do
		@md.find('http://data-vocabulary.org/Review').first[:type].should eq 'http://data-vocabulary.org/Review'
		@md.find().first[:type].should == 'http://data-vocabulary.org/Review'
	end

	it 'should return all the properties from the text with the correct values' do
		expected_properties = {
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
		@md.find().first[:properties].should == expected_properties
	end

end

describe Microdata, 'when run against a full html document containing two itemscopes with itemtypes' do

	before do
		html = '
			<html>
				<head>
				</head>
				<body>
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
				</body>
			</html>
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

		itemscope_names.each { |name, num| num.should == 1 }
	end

	it 'should give the type of each itemscope if specified' do
		itemscope_names = [
			'http://data-vocabulary.org/Review',
			'http://data-vocabulary.org/Organization'
		]

		itemscope_names.each do |vocab|
			@md.find(vocab).first[:type].should == vocab
		end
	end

	it 'should return all the properties from the text for 1st itemscope' do
		expected_properties = {
			'itemreviewed' => 'Romeo Pizza',
			'rating' => '4.5'
		}
		properties = @md.find('http://data-vocabulary.org/Review').first[:properties]
		properties.should == expected_properties
	end

	it 'should return all the properties from the text for 2nd itemscope' do
		expected_properties = {
			'name' => 'IBM',
			'url' => 'http://ibm.com'
		}
		properties = @md.find('http://data-vocabulary.org/Organization').first[:properties]
		properties.should == expected_properties
	end

end
