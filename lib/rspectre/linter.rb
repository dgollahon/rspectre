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

      raw_node = RSpectre::SOURCES.node_map(file).find_let(line)

      if raw_node
        node = RSpectre::Node.new(file, line, raw_node)
        TRACKER.register(self::TAG, node)
        yield node
      end

      nil
    end

    def self.record(node)
      TRACKER.record(self::TAG, node)
    end

    def self.prepend_behavior(scope, method_name)
      original_method = scope.instance_method(method_name)

      scope.__send__(:define_method, method_name) do |*args, &block|
        yield

        original_method.bind(self).(*args, &block)
      end
    end
  end
end
