# frozen_string_literal: true

module RSpectre
  class SourceFiles
    include Concord.new(:cache)

    def initialize
      super({})
    end

    def node_map(file)
      cache[file] ||= SourceMap.parse(file)
    end
  end
end
