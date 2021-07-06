# frozen_string_literal: true

RSpec.describe RSpectre do
  include_examples 'highlighted offenses', <<~RUBY
    RSpec.describe 'unused double methods' do
      describe 'some double' do
        it 'works' do
          numeric = double('Float', to_i: 1, to_s: '1.0')
                                             ^^^^ UnusedDoubleMethod: Unused double method.
          expect(numeric.to_i).to be(1)
        end

        it 'works' do
          numeric = double('Float', to_i: 1)
          expect(numeric.to_i).to be(1)
        end

        it 'works' do
          numeric = double('Float', to_i: 1, to_s: '1.0')
                                    ^^^^ UnusedDoubleMethod: Unused double method.
          expect(numeric.to_s).to eql('1.0')
        end

        it 'works' do
          numeric = double('Float')
          expect(numeric).to_not be(nil)
        end
      end
    end
  RUBY

  it 'works' do
    numeric = double('Float', to_i: 1, to_s: '1.0')

    expect(numeric.to_i).to be(1)
  end
end
