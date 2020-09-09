# frozen_string_literal: true

RSpec.describe RSpectre::Runner do
  include_context 'rspectre runner'

  it 'outputs a success message' do
    source = <<~RUBY
      RSpec.describe 'nothing of interest here' do
        let(:a) { 1 }

        it 'is 1' do
          expect(a).to be(1)
        end
      end
    RUBY

    run_rspectre(source) do |(stdout, _stderr, status), _spec_file|
      expect(status.to_i).to be(0)
      expect(stdout).to eql("No unused test setup detected.\n")
    end
  end
end
