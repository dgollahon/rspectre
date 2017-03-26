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

      def self.find_node(node_map, line)
        node_map.find_method(:let, line)
      end
    end
  end
end
