# frozen_string_literal: true

module RSpectre
  class Runner
    include Concord.new(:rspec_arguments, :auto_correct)

    EXIT_SUCCESS = 0

    def initialize(*)
      super
      @rspec_output = StringIO.new
    end

    def lint
      if run_specs.equal?(EXIT_SUCCESS)
        handle_offenses
      else
        exit_with_error
      end
    end

    private

    attr_reader :rspec_output

    def handle_offenses
      if TRACKER.offenses?
        auto_correct ? TRACKER.correct_offenses : TRACKER.report_offenses
      else
        puts 'No unused test setup detected.'
      end
    end

    # The version of `rubocop` we are currently using has an issue with leading whitespace in
    # heredocs.
    # rubocop:disable Layout/EmptyLinesAroundArguments
    def exit_with_error
      rspec_output.rewind

      abort(
        Color.red(
          'Running the specs failed. Either your tests do not pass '\
          'normally or this is a bug in RSpectre.'
        ) + <<~TEXT


          RSpec Output:
          ---
          #{rspec_output.read}
        TEXT
      )
    end
    # rubocop:enable Layout/EmptyLinesAroundArguments

    def run_specs
      RSpec::Core::Runner.run(rspec_arguments, $stderr, rspec_output)
    end
  end
end
