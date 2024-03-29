# frozen_string_literal: true

module RSpectre
  class Linter
    SOURCE_FILES = {} # rubocop:disable Style/MutableConstant

    def self.example_group
      RSpec::Core::ExampleGroup
    end

    def self.register(selector, locations)
      location = locations.first

      file = File.realpath(location.path)
      line = location.lineno

      return unless file.to_s.start_with?(File.realpath(Dir.pwd))

      raw_node = node_map(file).find_method(selector, line)

      if raw_node
        node = RSpectre::Node.new(file: file, line: line, node: raw_node)
        TRACKER.register(self::TAG, node)
        if block_given?
          yield node
        else
          node
        end
      end
    end

    def self.node_map(file)
      SOURCE_FILES[file] ||= SourceMap.parse(file)
    end

    def self.record(node)
      TRACKER.record(self::TAG, node)
    end

    def self.prepend_behavior(scope, method_name)
      original_method = scope.instance_method(method_name)

      # Removing the method first prevents method redefined warnings when $VERBOSE is true
      scope.remove_method(method_name)
      scope.__send__(:define_method, method_name) do |*args, **kwargs, &block|
        yield

        original_method.bind_call(self, *args, **kwargs, &block)
      end
    end

    private_constant(*constants(false))
    private_class_method(*singleton_methods(false) - %i[record register prepend_behavior])
  end
end
