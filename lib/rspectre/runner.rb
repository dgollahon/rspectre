# frozen_string_literal: true

module RSpectre
  class Runner
    include Concord.new(:rspec_arguments, :auto_correct)

    EXIT_SUCCESS = 0

    def lint
      if runner.run_specs(RSpec.world.ordered_example_groups).equal?(EXIT_SUCCESS)
        handle_offenses
      else
        exit_with_error
      end
    end

    private

    def handle_offenses
      if TRACKER.offenses?
        auto_correct ? TRACKER.correct_offenses : TRACKER.report_offenses
      end
    end

    def exit_with_error
      abort(
        Color.red(
          'Running the specs failed. Either your tests do not pass '\
          'normally or this is a bug in RSpectre.'
        )
      )
    end

    def runner
      rspec_config = RSpec::Core::ConfigurationOptions.new(rspec_arguments)

      RSpec::Core::Runner.new(rspec_config).tap { |runner| runner.setup($stderr, StringIO.new) }
    end
  end
end
