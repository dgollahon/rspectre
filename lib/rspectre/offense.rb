# frozen_string_literal: true

module RSpectre
  class Offense
    include Anima.new(:file, :line, :source_line, :start_column, :end_column, :type)

    DESCRIPTIONS = {
      'UnusedLet'         => 'Unused `let` definition.',
      'UnusedSubject'     => 'Unused `subject` definition.',
      'UnusedSharedSetup' => 'Unused `shared_examples`, `shared_examples_for`, or'\
                             ' `shared_context` definition.'
    }.freeze

    def self.parse(type, node)
      new(
        file:         node.file,
        line:         node.line,
        source_line:  node.source_line,
        start_column: node.start_column,
        end_column:   node.end_column,
        type:         type
      )
    end

    def warn
      puts to_s
    end

    # rubocop:disable Layout/IndentHeredoc
    def to_s
      <<~DOC

          #{source_id}: #{offense_type}: #{description}
              #{source_line}
              #{highlight}
      DOC
    end
    # rubocop:enable Layout/IndentHeredoc

    def description
      DESCRIPTIONS.fetch(type)
    end

    private

    def source_id
      Color.light_blue("#{file}:#{line}:#{start_column}")
    end

    def offense_type
      Color.yellow(type)
    end

    def highlight
      ' ' * (start_column - 1) + carets(end_column - start_column)
    end

    def carets(n)
      Color.yellow('^' * n)
    end
  end
end
