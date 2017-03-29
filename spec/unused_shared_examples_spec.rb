# frozen_string_literal: true

RSpec.describe RSpectre do
  include_examples 'highlighted offenses', <<~RUBY
    RSpec.shared_examples 'garbage examples' do
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ UnusedSharedSetup: Unused `shared_examples`, `shared_examples_for`, or `shared_context` definition.

    end

    shared_context 'garbage context' do
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ UnusedSharedSetup: Unused `shared_examples`, `shared_examples_for`, or `shared_context` definition.
    end

    RSpec.shared_examples_for 'used global constant form' do
    end

    shared_context 'used global' do
    end

    RSpec.describe 'unused shared setup' do
      shared_examples_for 'unused foo', :bar do
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ UnusedSharedSetup: Unused `shared_examples`, `shared_examples_for`, or `shared_context` definition.
        it { 'hi' }
      end

      context 'unused bar' do
        shared_examples 'bar' do
        ^^^^^^^^^^^^^^^^^^^^^ UnusedSharedSetup: Unused `shared_examples`, `shared_examples_for`, or `shared_context` definition.
        end
      end

      describe 'unused qux' do
        shared_context 'qux' do
        ^^^^^^^^^^^^^^^^^^^^ UnusedSharedSetup: Unused `shared_examples`, `shared_examples_for`, or `shared_context` definition.
          shared_examples 'x' do
          end

          specify { 'an example' }
        end
      end

      shared_context 'used context', :tag do
        let(:used_item) { 'something' }
      end

      shared_examples_for 'used (but pointless) context', meta: :data do
        let(:unused_item) { 'something' }
        ^^^^^^^^^^^^^^^^^ UnusedLet: Unused `let` definition.
      end

      shared_examples 'used example' do
        include_context  'used context'
        include_examples 'used (but pointless) context'

        specify { expect(used_item).to eql('something') }
      end

      shared_examples 'used with arguments and customization block' do |a, b|
        specify { expect(b).to be(2)  }
        specify { expect(a).to eql(c) }
      end

      include_examples('used with arguments and customization block', 1, 2) do
        let(:c) { 1 }
      end

      it_behaves_like('used with arguments and customization block', :value, 2) do
        let(:c) { :value }
      end

      shared_examples 'class_exec is needed for proper method inclusion' do
        def zapp_brannigan(*)
          'kif, show them the medal i won'
        end

        before { zapp_brannigan }
      end

      include_examples 'used example'
      include_examples 'used global constant form'
      include_examples 'used global'
      include_examples 'class_exec is needed for proper method inclusion'
    end
  RUBY
end
