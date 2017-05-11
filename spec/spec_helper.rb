# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
$LOAD_PATH.unshift(File.expand_path('../spec', __dir__))

require 'open3'
require 'tempfile'

require 'rspectre'

require 'shared/highlighted_offenses'

RSpec.configure do |config|
  # Forbid RSpec from monkey patching any of our objects
  config.disable_monkey_patching!

  # We should address configuration warnings when we upgrade
  config.raise_errors_for_deprecations!

  # RSpec gives helpful warnings when you are doing something wrong.
  # We should take their advice!
  config.raise_on_warning = true
end
