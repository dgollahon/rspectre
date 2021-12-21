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

  gem.required_ruby_version = '>= 2.6'

  gem.add_runtime_dependency('anima',    '~> 0.3')
  gem.add_runtime_dependency('concord',  '~> 0.1')
  gem.add_runtime_dependency('parser',   '>= 2.6')
  gem.add_runtime_dependency('rspec',    '~> 3.0')

  gem.add_development_dependency('pry',           '~> 0.14')
  gem.add_development_dependency('rubocop',       '~> 1.17.0')
  gem.add_development_dependency('rubocop-rspec', '~> 2.4.0')
end
