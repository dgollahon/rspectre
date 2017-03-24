# frozen_string_literal: true

module RSpectre
  class Runner
    include Concord.new(:runner, :world)

    EXIT_SUCCESS = 0

    def initialize(*rspec_arguments)
      rspec_arguments << 'spec' if rspec_arguments.empty?

      super(
        RSpec::Core::Runner.new(RSpec::Core::ConfigurationOptions.new(rspec_arguments)),
        RSpec.world
      )

      runner.setup($stderr, StringIO.new)
    end

    def lint
      if runner.run_specs(world.ordered_example_groups).equal?(EXIT_SUCCESS)
        TRACKER.report_offenses
      else
        abort(
          Color.red(
            'Running the specs failed. Either your tests do not pass '\
            'normally or this is a bug in RSpectre.'
          )
        )
      end
    end
  end # Rspec
end
