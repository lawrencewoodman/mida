task :default => :spec

desc "Create Gem"
require 'rake/gempackagetask'
spec = Gem::Specification.new do |s|
  s.name        = "mida"
  s.summary     = "A Microdata parser"
  s.description = File.read(File.join(File.dirname(__FILE__), 'README.md'))
  s.version     = "0.0.0"
  s.author      = "Lawrence Woodman"
  s.email       = "lwoodman@vlifesystems.com"
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>=1.9'
  s.files       = Dir['lib/**/*.rb'] + Dir['spec/**/*.rb'] + Dir['*.md'] + Dir['Rakefile']
  s.has_rdoc    = true
  s.extra_rdoc_files = ['README.md', 'LICENSE.md']
  s.rdoc_options = '--main README.md'
  s.add_dependency('nokogiri')
  s.add_development_dependency('rspec')
end
Rake::GemPackageTask.new(spec).define

desc "Run Specs"
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
