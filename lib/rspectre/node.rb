# frozen_string_literal: true

module RSpectre
  class Node
    include Concord::Public.new(:file, :line, :node)

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
      # TODO
      if node.type.equal?(:block)
        node.children.first.location
      else
        node.location
      end
    end
  end
end
