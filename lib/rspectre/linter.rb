# frozen_string_literal: true

module RSpectre
  class Linter
    SOURCE_FILES = {} # rubocop:disable Style/MutableConstant

    def self.example_group
      RSpec::Core::ExampleGroup
    end

    def self.mocks
      RSpec::Mocks::ExampleMethods
    end

    def self.register(selector, locations)
      node =
        resolve_sourcemap(locations.first) do |source_map, line|
          source_map.find_method(selector, line)
        end

      if node
        TRACKER.register(self::TAG, node)
        if block_given?
          yield node
        else
          node
        end
      end
    end

    # TODO: Check into general hash v.s. kwarg
    def self.find_kwarg(selector, kwarg_name, location)
      resolve_sourcemap(location) do |source_map, line|
        source_map.find_kwarg(selector, kwarg_name, line)
      end
    end

    def self.resolve_sourcemap(location)
      file = File.realpath(location.path)
      line = location.lineno

      return unless file.to_s.start_with?(File.realpath(Dir.pwd))

      raw_node = yield(node_map(file), line)
      raw_node && RSpectre::Node.new(file, line, raw_node)
    end

    def self.node_map(file)
      SOURCE_FILES[file] ||= SourceMap.parse(file)
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

    private_constant(*constants(false))
    private_class_method(*singleton_methods(false) - %i[record register prepend_behavior find_method_node find_kwarg])
  end
end
