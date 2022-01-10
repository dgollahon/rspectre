# frozen_string_literal: true

module RSpectre
  class AutoCorrector < Parser::TreeRewriter
    include Concord.new(:filename, :nodes, :buffer)

    def initialize(filename, nodes)
      buffer = Parser::Source::Buffer.new("(#{filename})")
      buffer.source = File.read(filename)

      super(filename, nodes, buffer)
    end

    def correct
      File.write(
        filename,
        rewrite(buffer, Parser::CurrentRuby.new.parse(buffer))
      )
    end

    def on_block(node)
      remove(removal_range(node)) if nodes.any? do |offense_node|
        node == offense_node && node.location.line == offense_node.location.line
      end

      super
    end

    private

    # This corrects for cases which contains heredocs which do not get removed in all cases if we
    # just use the `expression` range.
    def removal_range(node)
      Parser::Source::Range.new(
        buffer,
        node.location.expression.begin_pos,
        range_end(node)
      )
    end

    def range_end(node)
      location = node.location.expression

      last_line    = location.last_line
      end_location = location.end

      walk(node) do |child|
        child_location = child.location

        next unless child_location.respond_to?(:heredoc_end)

        heredoc_end = child_location.heredoc_end

        if heredoc_end.last_line > last_line
          last_line    = heredoc_end.last_line
          end_location = heredoc_end
        end
      end

      end_location.end_pos
    end

    def walk(node, &block)
      yield node

      node.children.each do |child|
        next unless child.is_a?(::Parser::AST::Node)

        walk(child, &block)
      end
    end
  end
end
