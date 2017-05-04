# frozen_string_literal: true

module RSpectre
  class Tracker
    include Concord.new(:registry, :tracker)

    def initialize
      super(Hash.new { Set.new }, Hash.new { Set.new })
    end

    def register(type, node)
      registry[type] <<= node
    end

    def record(type, node)
      tracker[type] <<= node
    end

    def report_offenses
      offenses.each(&:warn)
      abort
    end

    def offenses?
      offenses.any?
    end

    def correct_offenses
      registry.flat_map { |type, locations| (locations - tracker[type]).to_a }
        .group_by(&:file)
        .transform_values { |nodes| nodes.map(&:node) }
        .each do |file, nodes|
          AutoCorrector.new(file, nodes).correct
        end
    end

    private

    def offenses
      registry.flat_map do |type, locations|
        missing = locations - tracker[type]

        missing.map { |node| Offense.parse(type, node) }
      end
    end
  end
end
