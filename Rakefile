task :default => :spec

desc "Create Gem"
require 'rake/gempackagetask'
spec = Gem::Specification.new do |s|
  s.name        = "mida"
  s.summary     = "A Microdata parser/extractor library"
  s.description = "A Microdata parser and extractor library, based on the latest published version of the Microdata Specification, dated 5th April 2011."
  s.version     = "0.3.0"
  s.author      = "Lawrence Woodman"
  s.email       = "lwoodman@vlifesystems.com"
  s.homepage    = %q{http://lawrencewoodman.github.com/mida/}
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>=1.9'
  s.files       = Dir['lib/**/*.rb'] + Dir['spec/**/*.rb'] + Dir['*.rdoc'] + Dir['Rakefile']
  s.extra_rdoc_files = ['README.rdoc', 'LICENSE.rdoc', 'CHANGELOG.rdoc']
  s.rdoc_options << '--main' << 'README.rdoc'
  s.add_dependency('nokogiri')
  s.add_development_dependency('rspec', '>= 2.0' )
end
Rake::GemPackageTask.new(spec).define

desc "Run Specs"
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
