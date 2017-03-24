# frozen_string_literal: true

module RSpectre
  class Linter
    def self.example_group
      RSpec::Core::ExampleGroup
    end

    def self.register(locations)
      location = locations.first

      file = location.path
      line = location.lineno

      RSpectre::Node.new(file, RSpectre::SOURCES.node_map(file).find_let(line)).tap do |node|
        TRACKER.register(self::TAG, node)
      end
    end

    def self.record(node)
      TRACKER.record(self::TAG, node)
    end
  end
end
