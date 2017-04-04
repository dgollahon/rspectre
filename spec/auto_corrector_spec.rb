# frozen_string_literal: true

RSpec.describe RSpectre::AutoCorrector do
  let(:spec_file) do
    Tempfile.new.tap do |file|
      file.write(src)
      file.flush
    end
  end

  let(:src) do
    <<~RUBY
      RSpec.describe Foo do
        let(:foo) do
          'a'
          let(:bar) do
            let(:baz) { 'c' }
          end
        end
      end
    RUBY
  end

  before do
    spec_file
  end

  it 'corrects the selected offenses' do
    aggregate_failures do
      expect do
        described_class.new(
          spec_file.path,
          [RSpectre::SourceMap.parse(spec_file).find_method(:let, 4)]
        ).correct
      end.not_to raise_error

      expect(File.read(spec_file.path)).to eql(<<~RUBY)
        RSpec.describe Foo do
          let(:foo) do
            'a'
            \n  end
        end
      RUBY
    end
  end

  after do
    spec_file.close
    spec_file.unlink
  end
end
