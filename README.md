# RSpectre

[![CircleCI](https://circleci.com/gh/dgollahon/rspectre/tree/master.svg?style=shield)](https://circleci.com/gh/dgollahon/rspectre/tree/master)
[![Code Climate](https://codeclimate.com/github/dgollahon/rspectre/badges/gpa.svg)](https://codeclimate.com/github/dgollahon/rspectre)
[![Test Coverage](https://codeclimate.com/github/dgollahon/rspectre/badges/coverage.svg)](https://codeclimate.com/github/dgollahon/rspectre/coverage)
[![Gem Version](https://badge.fury.io/rb/rspectre.svg)](https://badge.fury.io/rb/rspectre)

`rspectre` is a tool to remove the dead and errant code haunting your test suite.

Static analysis tools like [rubocop-rspec](https://github.com/backus/rubocop-rspec), while very helpful in their own right, generally cannot detect most unused or misused test setup (especially when it spans multiple files) or are forced to have high false positive rates.

`rspectre` works a bit differently. By probing your test suite as it runs, `rspectre` can reliably detect and remove a number of common mistakes with virtually no false positives, including:

- Unused `let` statements
- Unused `subject` statements
- Unused `shared_context` and `shared_examples` statements

##### Example Spec

```ruby
RSpec.describe 'example' do
  subject { 'i get overridden later' }

  let(:foo) { 'an unused foo' }

  shared_examples 'unused example' do
    it 'is useless since it is not included' do
      expect(2 + 2).to eql(5)
    end
  end

  shared_examples 'used' do
    let(:bar) { 'an unused bar' }

    it 'asserts something' do
      expect(subject).to eql(baz)
    end
  end

  context 'some context' do
    subject { 'x' }

    let(:baz) { 'x' }

    include_examples 'used'
  end
end
```

##### `rspectre` output

![tool output](http://i.imgur.com/lbowIrc.png)

### Installation

To install `rspectre`, run:

```shell
$ gem install rspectre
```

or add

```ruby
gem 'rspectre'
```

to your Gemfile.

### Usage

Simply running

```shell
$ rspectre
```

will invoke your `rspec` test suite and check for various offenses. It runs `rspec` with `rspec --fail-fast spec` by default. If you need to pass custom arguments to rspec, you can use the `--rspec` flag and pass a quoted string of rspec arguments, as shown below:

```shell
$ rspectre --rspec '--some-rspec-flag tests'
```

If you want to automatically delete dead code that `rspectre` finds, simply use the `--auto-correct` flag.

```shell
$ rspectre --auto-correct
```

Note: `--auto-correct` is unpolished and may leave behind awkward whitespace or otherwise misbehave. YMMV.

##### NOTE

You should generally run your _entire_ test suite with `rspectre`. `rspectre` inserts probes in all of your specs and helpers as they are `require`'d and then waits to observe them being used. If, for example, your spec helper requires all your shared examples but you only run a subset of your tests (which don't happen to use all of the aforementioned shared examples), it may appear to `rspectre` like some of those shared examples are unused when they are not. If you do not run your whole test suite, you'll likely have to sift through some false positives.

### Supported Tool Versions

My intent is to support all non-EOL ruby versions and the last 4 minor versions of `rspec`. At the time of writing (2024-11-28), those are (`3.0`, `3.1`, `3.2`) and (`3.10`, `3.11`, `3.12`, and `3.13`, respectively). If you encounter an issue on a different version of `rspec`, please try upgrading first. If you still have a problem, please file an issue.

### Contributing

Please try out `rspectre` on your codebase--I'd love general feedback and, especially, bug reports. If you find something weird or `--auto-correct` eats your dog along with your homework, open an issue!

Also, if you have an idea for something you think `rspectre` might be able to reasonably detect, feel free to propose it in an issue as well.
