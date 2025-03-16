# Changelog

## [Master (Unreleased)]

- Fix argument forwarding in shared examples and contexts [#91](https://github.com/dgollahon/rspectre/pull/91) ([@dgollahon])
- Add support for ruby 3.4 [#89](https://github.com/dgollahon/rspectre/pull/89) ([@dgollahon])
- Remove support for ruby 3.0 [#88](https://github.com/dgollahon/rspectre/pull/88) ([@dgollahon])
- Suppress method redefined warnings when `$VERBOSE` is `true` [#80](https://github.com/dgollahon/rspectre/pull/80) ([@dgollahon])

## [0.1.0]

- Detect `let`s and other constructs using a block-pass like `let(:example, &block)` [#76](https://github.com/dgollahon/rspectre/pull/76) ([@dgollahon])
- Fix keyword forwarding for ruby 3.x [#71](https://github.com/dgollahon/rspectre/pull/71) and [#73](https://github.com/dgollahon/rspectre/pull/73) ([@bquorning], [@dgollahon])
- Dropped support for ruby 2.7 - [#72](https://github.com/dgollahon/rspectre/pull/72) ([@dgollahon])
- Improve test coverage and officially support the last 4 minor versions of `rspec` and all non-EOL `ruby` versions. [#70](https://github.com/dgollahon/rspectre/pull/70) ([@dgollahon])
- Remove `concord`, `anima`, and their transitive dependencies; nice! - [#69](https://github.com/dgollahon/rspectre/pull/69)
- Slightly improve performance via `#bind_call` - [#59](https://github.com/dgollahon/rspectre/pull/59) ([@dgollahon])
- Dropped support for ruby 2.6 - [#58](https://github.com/dgollahon/rspectre/pull/58) ([@dgollahon])

## [0.0.4]

- Fixed `parser` version constraint - [#43](https://github.com/dgollahon/rspectre/pull/43) ([@dgollahon]) (+ thanks @chiastolite)
- Re-enabled diagnostic warnings - [#39](https://github.com/dgollahon/rspectre/pull/39) ([@dgollahon])
- Dropped support for ruby 2.5 - [#53](https://github.com/dgollahon/rspectre/pull/53) (@alejandropere)

## [0.0.3]

- Added rspec output if the specs fail during an `rspectre` run - [#36](https://github.com/dgollahon/rspectre/pull/36) ([@dgollahon])
- Added success message if no unused setup is found - [#35](https://github.com/dgollahon/rspectre/pull/35) ([@dgollahon])
- Dropped support for ruby 2.3 and 2.4 - [#34](https://github.com/dgollahon/rspectre/pull/34) ([@dgollahon])
- Fixed a bug where `stringio` was not being required - [#32](https://github.com/dgollahon/rspectre/pull/32) ([@dgollahon])
- Removed `unparser` dependency - [#31](https://github.com/dgollahon/rspectre/pull/31) ([@dgollahon])

## [0.0.2]

- Added support for non-utf8 strings in tests - [#26](https://github.com/dgollahon/rspectre/pull/26) ([@dgollahon])
- Fixed heredoc removal during auto-correction - [#15](https://github.com/dgollahon/rspectre/pull/15) ([@dgollahon])

## 0.0.1

- Initial release, including the ability to

<!-- Version diffs -->

[master (unreleased)]: https://github.com/dgollahon/rspectre/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/dgollahon/rspectre/compare/v0.0.4...v0.1.0
[0.0.4]: https://github.com/dgollahon/rspectre/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/dgollahon/rspectre/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/dgollahon/rspectre/compare/6348bdefddbf8c9c267079c908eae9059d0a53cb...v0.0.2

<!-- Contributors -->

[@dgollahon]: https://github.com/dgollahon
[@bquorning]: https://github.com/bquorning
