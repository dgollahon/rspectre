# RSpectre

RSpectre is a tool for hunting the dead and errant code haunting your test suite. It picks up where static analysis tools like [rubocop-rspec](https://github.com/backus/rubocop-rspec) leave off by analyzing your test suite as it runs.

This project is still a work in progress.

### Planned Features

- [x] Detect unused `let` statements
- [x] Detect unused `subject` statements
- [x] Detect unused `shared_examples` and `shared_contexts`
- [ ] Detect unused double arguments
- [ ] Automatically delete dead code

...and many more, once i determine the feasibility of my various ideas.
