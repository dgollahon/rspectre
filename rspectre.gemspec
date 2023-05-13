# frozen_string_literal: true

require File.expand_path('lib/rspectre/version', __dir__)

Gem::Specification.new do |gem|
  gem.name        = 'rspectre'
  gem.version     = RSpectre::VERSION
  gem.summary     = 'A tool for linting RSpec test suites.'
  gem.authors     = ['Daniel Gollahon']
  gem.files       = `git ls-files lib`.split("\n")
  gem.executables = ['rspectre']
  gem.homepage    = 'http://github.com/dgollahon/rspectre'
  gem.license     = 'MIT'

  gem.required_ruby_version = '>= 2.7'

  gem.add_runtime_dependency('parser', '>= 3.2.2.1')
  gem.add_runtime_dependency('rspec',  '~> 3.9')

  gem.add_development_dependency('pry',           '~> 0.14')
  gem.add_development_dependency('rubocop',       '~> 1.51.0')
  gem.add_development_dependency('rubocop-rspec', '~> 2.22.0')

  gem.metadata['rubygems_mfa_required'] = 'true'
end
