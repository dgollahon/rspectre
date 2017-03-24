# frozen_string_literal: true

RSpec.describe RSpectre do
  include_examples 'highlighted offenses', <<~RUBY
    RSpec.describe 'unused lets' do
      let(:used)   { 'foo'  }

      let(:unused) { 'noop' }
      ^^^^^^^^^^^^ UnusedLet: Unused `let` definition.

      let(:unused_compound) { 1 + 1; 'noop' }
      ^^^^^^^^^^^^^^^^^^^^^ UnusedLet: Unused `let` definition.

      let(
      ^^^^ UnusedLet: Unused `let` definition.
        :unused_multine
      ) { 'noop' }

      let(:unused_multiline_block) do
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ UnusedLet: Unused `let` definition.
        'noop'
      end

      let(:unused_multiline_compound) do
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ UnusedLet: Unused `let` definition.
        'doop'
        'noop'
      end

      let(:inner_used_indirectly) { 'bar' }

      it 'works foo' do
        expect(used).to eql('foo')
      end

      context 'inner' do
        let(:inner_unused) { 'noop' }
        ^^^^^^^^^^^^^^^^^^ UnusedLet: Unused `let` definition.

        let(:inner_used_directly) { 'baz' }

        it 'works' do
          expect(inner_used_indirectly).to eql('bar')
          expect(inner_used_directly).to eql('baz')
        end
      end
    end
  RUBY
end
