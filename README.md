# RSpectre

[![CircleCI](https://circleci.com/gh/dgollahon/rspectre/tree/master.svg?style=shield)](https://circleci.com/gh/dgollahon/rspectre/tree/master)

`rspectre` is a tool for hunting the dead and errant code haunting your test suite. It picks up where static analysis tools like [rubocop-rspec](https://github.com/backus/rubocop-rspec) leave off by analyzing your test suite as it runs.

This project is still a bit of a work in progress. In particular, `--auto-correct` is still experimental and may leave behind awkward whitespace or otherwise misbehave. YMMV.

Happy testing!

### Planned Features

- [x] Detect unused `let` statements
- [x] Detect unused `subject` statements
- [x] Detect unused `shared_examples` and `shared_contexts`
- [x] Automatically delete dead code
- [ ] Detect unused double arguments

I have some other ideas in mind as well, but haven't evaluated how feasible they are yet.

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

##### NOTE

You should generally run your _entire_ test suite with `rspectre`. `rspectre` inserts probes in all of your specs and helpers as they are `require`'d and then waits to observe them being used. If, for example, your spec helper requires all your shared examples but you only run a subset of your tests (which don't happen to use all of the aforementioned shared examples), it may appear to `rspectre` like some of those shared examples are unused when they are not. I may consider trying to handle for some of these cases in the future, but for now just run your whole test suite or else you'll have to sift through some false positives.

### Contributing

Please try out `rspectre` on your codebase--I'd love general feedback and bug reports. If you find something weird or `--auto-correct` eats your dog along with your homework, open an issue!

Also, if you have an idea for something you think `rspectre` might be able to reasonably detect, feel free to propose it in an issue as well.
