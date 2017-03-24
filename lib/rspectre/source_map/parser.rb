# frozen_string_literal: true

module RSpectre
  class SourceMap
    class Parser
      include Concord.new(:file)

      def populate(map)
        walk(parsed_source) { |node| map.add(node) }

        map.freeze
      end

      private

      def walk(node, &block)
        yield node

        node.children.each do |child|
          next unless child.is_a?(::Parser::AST::Node)

          walk(child, &block)
        end
      end

      def parsed_source
        ::Parser::CurrentRuby.parse(raw_source)
      end

      def raw_source
        Pathname.new(file).read
      end
    end
  end
end
