# frozen_string_literal: true

module RSpectre
  class Linter
    class UnusedSubject < self
      TAG = 'UnusedSubject'

      def example_group.subject(name = nil, &block)
        super(*name, &block)

        UnusedSubject.register(caller_locations) do |node|
          UnusedSubject.prepend_behavior(self, name || :subject) { UnusedSubject.record(node) }
        end
      end

      def self.find_node(node_map, line)
        node_map.find_method(:subject, line)
      end
    end
  end
end
