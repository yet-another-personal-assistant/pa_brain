# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- License changed from MIT to GPLv2

## [0.4.0] - 2018-11-15
### Added
- Brain now accepts commands
- 'switch-user' command
- 'say' command
- Brain now handles events
- 'new-day' event
- 'presence' event
- 'gone' event
- Brain now sends a 'good morning' message when 'new-day' event occurs

### Changed
- Brain instance now has an "active user"
  - Messages from other users are discarded
  - Active user can be changed with 'switch-user' command
- Brain now remembers "active channel"
  - Messages are sent to that channel unless it's a response to another message
  - Active channel can be changed with 'presence' event
  - Active channel can be unset with 'gone' event

## [0.3.0] - 2018-11-04
### Added
- Instructions for running using clisp
- dont-understand response
- Initial unit test

### Fixed
- Argument parsing in clisp

### Changed
- Brain replies "dont-understand" instead of "unknown"
- Brain ignores messages without the "message" field

## [0.2.0] - 2018-08-31
### Added
- --translator argument

### Changed
- Translator is now required for brain to work

### Removed
- Makefile

## 0.1.0 - 2018-08-19
### Added
- License
- Readme
- This changelog
- Makefile for running the code
- run.lisp is the main entrypoint
- brain reads STDIN in infinite loop
- brain replies hardcoded value "Ой, приветик!" to "Привет" message
- brain replies "unknown" to messages it doesn't understand

[Unreleased]: https://github.com/aragaer/pa_brain/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/aragaer/pa_brain/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/aragaer/pa_brain/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/aragaer/pa_brain/compare/v0.1.0...v0.2.0
