# ctg.gemspec

require_relative 'lib/ctg/version'

Gem::Specification.new do |spec|
  spec.name          = 'ctg'
  spec.version       = CTG::VERSION
  spec.authors       = ['Leonid Stoianov']
  spec.email         = ['leo@@trialize.io']

  spec.summary       = 'A Ruby client for interacting with the ClinicalTrials.gov API.'
  spec.description   = 'CTG is a Ruby library that provides an interface for querying the ClinicalTrials.gov API. It supports both JSON and CSV formats, pagination, and complex queries.'
  spec.homepage      = 'https://github.com/trialize/ctg'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb'] + ['README.md', 'LICENSE']
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 7.1', '>= 7.1.3.2'
  spec.add_dependency 'httparty', '~> 0.22'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'webmock', '~> 3.23', '>= 3.23.1'

  spec.metadata['source_code_uri'] = 'https://github.com/trialize/ctg'
  spec.metadata['changelog_uri'] = 'https://github.com/trialize/ctg/CHANGELOG.md'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
end
