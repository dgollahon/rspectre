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
      if offenses.any?
        offenses.each(&:warn)
        abort
      end
    end

    def offenses
      registry.flat_map do |type, locations|
        missing = locations - tracker[type]

        missing.map { |node| Offense.parse(type, node) }
      end
    end
  end
end
