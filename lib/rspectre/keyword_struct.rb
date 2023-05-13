# frozen_string_literal: true

module RSpectre
  # Heavily influenced by dkubb/equalizer, mbj/concord, and mbj/anima
  class KeywordStruct < Module
    def initialize(*names) # rubocop:disable Lint/MissingSuper
      raise 'Specify at least one keyword name!' if names.empty?

      names.each do |name|
        next if /\A\w+\z/.match?(name)

        raise "Invalid keyword name #{name.inspect}!"
      end

      @module =
        Module.new do
          attr_reader(*names)

          define_method(:eql?) do |other|
            other.instance_of?(self.class) && names.all? do |name|
              __send__(name).eql?(other.__send__(name))
            end
          end
          alias_method :==, :eql?

          define_method(:inspect) do
            class_name = self.class.name || self.class.inspect
            attributes = names.map { |name| "#{name}=#{__send__(name).inspect}" }.join(' ')
            "#<#{class_name} #{attributes}>"
          end
        end.tap do |generated_module|
          generated_module.class_eval(<<~RUBY, __FILE__, __LINE__ + 1) # rubocop:disable Style/DocumentDynamicEvalDefinition
            def initialize(#{names.map { |name| "#{name}:" }.join(', ')})
              #{names.map { |name| "@#{name} = #{name}" }.join("\n  ")}
            end
          RUBY
        end
    end

    def included(descendant)
      descendant.include(@module)
    end
  end
end
