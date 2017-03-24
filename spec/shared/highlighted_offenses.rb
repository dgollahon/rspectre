# frozen_string_literal: true

RSpec.shared_examples 'highlighted offenses' do |src|
  subject(:lint) { `bin/rspectre #{spec_file.path}` }

  let(:spec_file) do
    Tempfile.new.tap do |file|
      file.write(src.gsub(/^\s*\^+.+\n/, ''))
      file.flush
    end
  end

  let(:expectations) do
    line_count = 0
    last_line  = ''

    src.split("\n").map do |current_line|
      header_pattern = /^(?<leading_space>\s*)(?<highlight>\^+)\s(?<tag>\w+):\s(?<message>.+)$/

      if (match = current_line.match(header_pattern))
        start_column = match[:leading_space].length + 1

        RSpectre::Offense.new(
          file:         spec_file.path,
          line:         line_count,
          source_line:  last_line,
          start_column: start_column,
          end_column:   start_column + match[:highlight].length,
          type:         match[:tag]
        )
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
      messages = lint.split("\n").each_slice(4)

      expect(messages.count).to eql(expectations.count)

      messages.zip(expectations) do |message_parts, expectation|
        expect(message_parts).to eql(expectation.to_s.split("\n"))
      end
    end
  end

  after do
    spec_file.close
    spec_file.unlink
  end
end
