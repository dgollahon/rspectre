# frozen_string_literal: true

module RSpectre
  class AutoCorrector < Parser::Rewriter
    include Concord.new(:filename, :nodes)

    def correct
      buffer = Parser::Source::Buffer.new("(#{filename})")
      buffer.source = File.read(filename)

      File.open(filename, 'w') do |file|
        file.write(rewrite(buffer, Parser::CurrentRuby.new.parse(buffer)))
      end
    end

    def on_block(node)
      remove(node.location.expression) if nodes.any? do |offense_node|
        node == offense_node && node.location.line == offense_node.location.line
      end

      super
    end
  end
end
