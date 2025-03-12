# frozen_string_literal: true

RSpec.describe RSpectre do
  include_examples 'highlighted offenses', <<~RUBY
    RSpec.describe 'unused lets' do
      let(:used)   { 'foo'  }

      let(:unused) { 'noop' }
      ^^^^^^^^^^^^ UnusedLet: Unused `let` definition.

      let(:unused_binary) { "\\xff".b }
      ^^^^^^^^^^^^^^^^^^^ UnusedLet: Unused `let` definition.

      let(:unused_compound) { foo; 'noop' }
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
        foo
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

      context 'duplicated name' do
        let(:used) { 'not actually used' }
        ^^^^^^^^^^ UnusedLet: Unused `let` definition.
      end

      context 'block-pass cases' do
        def self.block_example(&block)
          let(:used_block_pass,   &block)
          let(:unused_block_pass, &block)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ UnusedLet: Unused `let` definition.
        end

        block_example { 'neat!' }

        it 'detects block passes properly' do
          expect(used_block_pass).to eql('neat!')
        end
      end
    end
  RUBY

  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.4')
    include_examples 'highlighted offenses', <<~RUBY
      RSpec.describe 'unused lets' do
        let(:unused) { it }
        ^^^^^^^^^^^^ UnusedLet: Unused `let` definition.
      end
    RUBY
  end
end
