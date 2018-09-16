# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Instructions for running using clisp
- dont-understand response
- Initial unit test

### Fixed
- Argument parsing in clisp

### Changed
- Brain replies "dont-understand" instead of "unknown"

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

[Unreleased]: https://github.com/aragaer/pa_brain/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/aragaer/pa_brain/compare/v0.1.0...v0.2.0
