# frozen_string_literal: true

module RSpectre
  class SourceMap
    include KeywordStruct.new(:map)

    def initialize
      super(map: Hash.new { [] })
    end
    private_class_method :new

    def self.parse(file)
      self::Parser.new(file: file).populate(new)
    end

    def add(node)
      return unless node.loc.expression

      map[node.loc.first_line] <<= node
    end

    def find_method(target_selector, line)
      candidates = find_methods(target_selector, line)

      if candidates.one?
        candidates.first
      else
        warn Color.yellow("Unable to resolve `#{target_selector}` on line #{line}.")
      end
    end

    private

    def find_methods(target_selector, line)
      block_candidates =
        block_nodes(line).select do |node|
          send, = *node
          matching_send?(send, target_selector)
        end

      if block_candidates.any?
        block_candidates
      else
        send_nodes(line).select do |node|
          matching_send?(node, target_selector)
        end
      end
    end

    def matching_send?(node, method_name)
      _receiver, selector = *node

      selector.equal?(method_name)
    end

    def block_nodes(line)
      map.fetch(line, []).select { |node| node.type.equal?(:block) }
    end

    def send_nodes(line)
      map.fetch(line, []).select { |node| node.type.equal?(:send) }
    end

    class Null < self
      public_class_method :new

      def find_let(_)
      end
    end
  end
end
