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

      def self.parser_class
        if RSpectre.ruby_version_supports_prism?
          Prism::Translation::Parser
        else
          ::Parser::CurrentRuby
        end
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
        parser = self.class.parser_class.new(PermissiveASTBuilder.new)
        buffer = ::Parser::Source::Buffer.new(file, source: raw_source)
        parser.parse(buffer)
      end

      def raw_source
        Pathname.new(file).read
      end
    end
  end
end
