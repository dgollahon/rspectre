# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'pathname'
require 'set'
require 'stringio'

require 'rspec'
module RSpectre
  LIB_PATH = Pathname.new(File.expand_path('../lib', __dir__))

  MINIMUM_RUBY_FOR_PRISM = Gem::Version.new('3.3')
  private_constant(:MINIMUM_RUBY_FOR_PRISM)

  def self.ruby_version_supports_prism?
    Gem::Version.new(RUBY_VERSION) >= MINIMUM_RUBY_FOR_PRISM
  end
end

if RSpectre.ruby_version_supports_prism?
  require 'parser'
  require 'prism'
else
  require 'parser/current'
end

require 'rspectre/keyword_struct'

require 'rspectre/auto_corrector'
require 'rspectre/color'
require 'rspectre/node'
require 'rspectre/offense'
require 'rspectre/permissive_ast_builder'
require 'rspectre/runner'
require 'rspectre/source_map'
require 'rspectre/source_map/parser'
require 'rspectre/tracker'

require 'rspectre/linter'
require 'rspectre/linter/unused_let'
require 'rspectre/linter/unused_subject'
require 'rspectre/linter/unused_shared_setup'

module RSpectre
  TRACKER = Tracker.new
end
