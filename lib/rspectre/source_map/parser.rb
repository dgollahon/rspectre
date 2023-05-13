# frozen_string_literal: true

module RSpectre
  class SourceMap
    class Parser
      include KeywordStruct.new(:file)

      def populate(map)
        walk(parsed_source) { |node| map.add(node) }

        map.freeze
      rescue ::Parser::SyntaxError => error
        warn Color.yellow("Warning! Skipping #{file} due to parsing error!")
        warn error.diagnostic.render
        Null.new
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
        parser = ::Parser::CurrentRuby.new(PermissiveASTBuilder.new)
        buffer = ::Parser::Source::Buffer.new(file, source: raw_source)

        parser.parse(buffer)
      end

      def raw_source
        Pathname.new(file).read
      end
    end
  end
end
