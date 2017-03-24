# frozen_string_literal: true

module RSpectre
  module Color
    def self.red(str)
      colorize(str, 31)
    end

    def self.yellow(str)
      colorize(str, 33)
    end

    def self.light_blue(str)
      colorize(str, 36)
    end

    def self.colorize(str, color_code)
      "\e[#{color_code}m#{str}\e[0m"
    end
    private_class_method :colorize
  end
end
