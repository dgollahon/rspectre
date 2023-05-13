# frozen_string_literal: true

RSpec.describe RSpectre::KeywordStruct do
  subject(:struct) { Class.new.include(described_class.new(:foo, :bar)) }

  it 'defines keyword arguments' do
    expect { struct.new }.to raise_error('missing keywords: :foo, :bar')
  end

  it 'generates attr_readers' do
    expect(struct.new(foo: 1, bar: 2)).to have_attributes(
      foo: 1,
      bar: 2
    )
  end

  describe '#==' do
    it 'has appropriate equality semantics' do
      expect(struct.new(foo: 1, bar: 1)).to eq(struct.new(foo: 1, bar: 1)) # rubocop:disable RSpec/IdenticalEqualityAssertion
      expect(struct.new(foo: 1, bar: 1)).not_to eq(struct.new(foo: 2, bar: 1))
      expect(struct.new(foo: 1, bar: 1)).not_to eq(struct.new(foo: 1, bar: 2))
    end
  end

  describe '#eql?' do
    it 'has appropriate equality semantics' do
      expect(struct.new(foo: 1, bar: 1)).to eql(struct.new(foo: 1, bar: 1)) # rubocop:disable RSpec/IdenticalEqualityAssertion
      expect(struct.new(foo: 1, bar: 1)).not_to eql(struct.new(foo: 2, bar: 1))
      expect(struct.new(foo: 1, bar: 1)).not_to eql(struct.new(foo: 1, bar: 2))
    end
  end

  describe '#hash' do
    it 'correctly identifies unique elements' do
      set = [
        struct.new(foo: 1, bar: 1),
        struct.new(foo: 1, bar: 1),
        struct.new(foo: 2, bar: 2)
      ].to_set

      expect(set.to_a).to eql([struct.new(foo: 1, bar: 1), struct.new(foo: 2, bar: 2)])
    end
  end

  describe '#inspect' do
    it 'produces a legible inspect method' do
      expect(struct.new(foo: 1, bar: 1).inspect).to match(/<#<Class:0x\h+> foo=1 bar=1>/)
    end
  end
end
