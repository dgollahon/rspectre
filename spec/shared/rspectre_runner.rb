# frozen_string_literal: true

RSpec.shared_context 'rspectre runner' do # rubocop:disable RSpec/ContextWording
  def run_rspectre(source)
    spec_file =
      Tempfile.new(%w[spec_file .rb]).tap do |file|
        file.write(source.gsub(/^\s*\^+.+\n/, ''))
        file.flush
      end

    rspectre_path = File.expand_path('bin/rspectre')

    output =
      Dir.chdir(File.dirname(spec_file.path)) do
        Open3.capture3("RUBYOPT='--verbose' #{rspectre_path} --rspec #{spec_file.path}")
      end

    yield([output, spec_file])
  ensure
    spec_file.close
    spec_file.unlink
  end
end
