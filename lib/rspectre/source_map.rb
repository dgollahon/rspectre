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

    def find_method(target_selector, line)
      candidates = find_methods(target_selector, line)

      if candidates.one?
        candidates.first
      else
        warn Color.yellow("Unable to resolve `#{target_selector}` on line #{line}.")
      end
    end

    def find_kwarg(target_selector, kwarg_name, line)
      candidates =
        map.fetch(line, []).select { |node| node.type.equal?(:send) }
          .select do |node|
            _receiver, selector = *node;
            selector.equal?(target_selector)
          end

      # TODO: if ambiguous, could check for kwarg before asserting to disambiguate
      candidate =
        if candidates.one?
          candidates.first
        else
          warn Color.yellow("Unable to resolve `#{target_selector}` on line #{line}. XX")
        end

      _receiver, _selector, _name, stubs_node = *candidate

      unless stubs_node.type.equal?(:hash)
        warn Color.yellow("oh shit")
        return
      end

      stubs_node.children.each do |node|
        if node.type.equal?(:pair)
          kwarg_name_node = node.children.first
          if kwarg_name_node.children.first.eql?(kwarg_name)
            return kwarg_name_node
          end
        end
      end

      warn Color.yellow("oh shit 2")
      return
    end

    private

    def find_methods(target_selector, line)
      block_nodes(line).select do |node|
        send, = *node
        _receiver, selector = *send

        selector.equal?(target_selector)
      end
    end

    def block_nodes(line)
      map.fetch(line, []).select { |node| node.type.equal?(:block) }
    end

    class Null < self
      public_class_method :new

      def find_let(_)
      end
    end
  end
end
