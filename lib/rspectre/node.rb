# frozen_string_literal: true

module RSpectre
  class Node
    attr_reader :file, :line, :node

    def initialize(file, line, node)
      @file = file
      @line = line
      @node = node
    end

    def start_column
      location.column + 1
    end

    def end_column
      if single_line?
        location.last_column + 1
      else
        source_line.length + 1
      end
    end

    def source_line
      location.expression.source_line.rstrip
    end

    private

    def single_line?
      line.equal?(location.last_line)
    end

    def location
      node.children.first.location
    end
  end
end
