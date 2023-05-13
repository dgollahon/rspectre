# frozen_string_literal: true

RSpec.shared_examples 'highlighted offenses' do |source|
  include_context 'rspectre runner'

  def expected_offenses(source, spec_file)
    line_count = 0
    last_line  = ''

    source.split("\n").map do |current_line|
      header_pattern = /^(?<leading_space>\s*)(?<highlight>\^+)\s(?<tag>\w+):\s(?<message>.+)$/

      if (match = current_line.match(header_pattern))
        start_column = match[:leading_space].length + 1

        [
          RSpectre::Offense.new(
            file:         File.realpath(spec_file.path),
            line:         line_count,
            source_line:  last_line,
            start_column: start_column,
            end_column:   start_column + match[:highlight].length,
            type:         match[:tag]
          ),
          match[:message]
        ]
      else
        last_line = current_line
        line_count += 1
        next
      end
    end.compact
  end

  it 'highlights the expected offenses' do
    aggregate_failures do
      run_rspectre(source) do |(stdout, stderr, status), file|
        unless stderr.empty?
          puts 'STDERR:'
          puts stderr
        end

        offenses = stdout.split("\n").each_slice(4)
        expected_offenses = expected_offenses(source, file)

        expect(status.to_i).to be > 0
        expect(offenses.count).to eql(expected_offenses.count)

        offenses.zip(expected_offenses) do |message_parts, (offense, description)|
          expected_parts = offense.to_s.split("\n")

          expect(message_parts).to eql(expected_parts), <<~MSG
            Expected:
              #{expected_parts[0]}
              #{expected_parts[1]}
              #{expected_parts[2]}
              #{expected_parts[3]}
            Found:
              #{message_parts[0]}
              #{message_parts[1]}
              #{message_parts[2]}
              #{message_parts[3]}
          MSG

          expect(offense.description).to eql(description)
        end
      end
    end
  end
end
