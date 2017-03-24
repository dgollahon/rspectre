# frozen_string_literal: true

module RSpectre
  class Linter
    class UnusedLet < self
      TAG = 'UnusedLet'

      def example_group.let(*args, &block)
        node = UnusedLet.register(caller_locations)

        super(*args) do
          UnusedLet.record(node)

          instance_exec(&block)
        end
      end
    end
  end
end
