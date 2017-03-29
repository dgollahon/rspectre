# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'pathname'
require 'set'

require 'anima'
require 'concord'
require 'parser/current'
require 'rspec'
require 'unparser'

require 'rspectre/color'
require 'rspectre/node'
require 'rspectre/offense'
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
