# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mida/version'

Gem::Specification.new do |spec|
  spec.name          = "mida"
  spec.version       = Mida::VERSION
  spec.author      = "Lawrence Woodman"
  spec.email       = "lwoodman@vlifesystems.com"
  spec.description = "A Microdata parser and extractor library which includes support for the schema.org vocabularies"
  spec.summary     = "A Microdata parser/extractor library"
  spec.homepage    = %q{http://lawrencewoodman.github.io/mida/}
  spec.license       = "MIT"
  spec.files         = `git ls-files`.split($/)
  spec.executables   = ['mida']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.extra_rdoc_files = ['README.rdoc', 'LICENCE.rdoc', 'CHANGELOG.rdoc']
  spec.rdoc_options << '--main' << 'README.rdoc'
  spec.add_dependency('blankslate', '3.1.3')
  spec.add_dependency('nokogiri', '>= 1.6')
  spec.add_dependency('addressable', '~> 2.4')
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.10.0"
end
