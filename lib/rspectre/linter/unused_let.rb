# frozen_string_literal: true

module RSpectre
  class Linter
    class UnusedLet < self
      TAG = 'UnusedLet'

      def example_group.let(name, &block)
        super(name, &block)

        UnusedLet.register(caller_locations) do |node|
          UnusedLet.prepend_behavior(self, name) { UnusedLet.record(node) }
        end
      end
    end
  end
end
