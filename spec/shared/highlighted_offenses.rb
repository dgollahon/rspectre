# frozen_string_literal: true

RSpec.shared_examples 'highlighted offenses' do |src|
  subject(:lint) { `bin/rspectre #{spec_file.path}` }

  let(:spec_file) do
    Tempfile.new.tap do |file|
      file.write(src.gsub(/^\s*\^+.+\n/, ''))
      file.flush
    end
  end

  let(:expected_offenses) do
    line_count = 0
    last_line  = ''

    src.split("\n").map do |current_line|
      header_pattern = /^(?<leading_space>\s*)(?<highlight>\^+)\s(?<tag>\w+):\s(?<message>.+)$/

      if (match = current_line.match(header_pattern))
        start_column = match[:leading_space].length + 1

        [
          RSpectre::Offense.new(
            file:         spec_file.path,
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

  before do
    spec_file
  end

  it 'highlights the offenses' do
    aggregate_failures do
      offenses = lint.split("\n").each_slice(4)

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

  after do
    spec_file.close
    spec_file.unlink
  end
end
