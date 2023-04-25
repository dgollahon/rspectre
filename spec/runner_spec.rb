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

  it 'outputs rspec messages when the tests fail' do
    source = <<~RUBY
      RSpec.describe 'failures' do
        it { raise 'uh oh' }
      end
    RUBY

    run_rspectre(source) do |(stdout, stderr, status), _spec_file|
      expect(status.to_i).to be > 0
      expect(stdout).to eql('')
      expect(
        stderr.gsub(/\d\.\d+/, '<time>').gsub(/\S+\.rb/, '<file>').strip
      ).to eql(<<~ERROR.strip)
        \e[31mRunning the specs failed. Either your tests do not pass normally or this is a bug in RSpectre.\e[0m

        RSpec Output:
        ---
        F

        Failures:

          1) failures \n\
             Failure/Error: it { raise 'uh oh' }

             RuntimeError:
               uh oh
             # <file>:2:in `block (2 levels) in <top (required)>'
             # <file>:57:in `run_specs'
             # <file>:16:in `lint'

        Finished in <time> seconds (files took <time> seconds to load)
        1 example, 1 failure

        Failed examples:

        rspec <file>:2 # failures
      ERROR
    end
  end
end
