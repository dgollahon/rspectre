# frozen_string_literal: true

module RSpectre
  class Linter
    class UnusedSubject < self
      TAG = 'UnusedSubject'

      def example_group.subject(name = nil, &)
        super(*name, &)

        UnusedSubject.register(:subject, caller_locations) do |node|
          UnusedSubject.prepend_behavior(self, :subject) { UnusedSubject.record(node) }
          alias_method name, :subject if name
        end
      end
    end
  end
end
