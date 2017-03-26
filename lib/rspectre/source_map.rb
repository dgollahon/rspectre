# frozen_string_literal: true

module RSpectre
  class SourceMap
    include Concord.new(:map)

    def initialize
      super(Hash.new { [] })
    end
    private_class_method :new

    def self.parse(file)
      self::Parser.new(file).populate(new)
    end

    def add(node)
      return unless node.loc.expression

      map[node.loc.first_line] <<= node
    end

    def find_let(line)
      lets = find_methods(line, :let)

      case lets.length
      when 0
        fail "Unable to resolve `let` on line #{line}."
      when 1
        lets.first
      else
        fail "Multiple `let`s on line #{line}. Unable to resolve a specific `let`."
      end
    end

    private

    def find_methods(line, target)
      send_nodes(line).select do |node|
        _receiver, selector = *node

        selector.equal?(target)
      end
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
