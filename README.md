# Personal Assistant brain

This is the brain behind my virtual personal assistant. It implements
all the communication scenarios.

### Protocol

Brain accepts messages on its standard input and writes replies to
standard output. Messages are one-lined json objects having the
following fields:

- `message`: text sent by user or pa
- `from`: anything
- `to`: anything

`from` and `to` fields are not currently used but are required by the
current `pa-brain` implementation. Messages without `message` field
are silently ignored.

## Commands
Brain currently understands/replies the following:

- `hello` - reply `hello`
- anything else - reply `dont-understand`

## Requirements

- [quicklisp](https://www.quicklisp.org/beta/)
- Translator ([pa2human v0.1.0+](https://github.com/aragaer/pa2human) or any other implementation) must be running

### Lisp implementations

Currently supported implementations are SBCL and Clisp.

#### Rawsock

Using Clisp requires `RAWSOCK` feature. Some distributions do not have
`RAWSOCK` enabled by default, it is possible it is included in `full`
linkingset. Use the following command to verify if `RAWSOCK` is available:

    clisp --version | grep -o RAWSOCK
	
If the result is empty, try

    clisp -K full --version | grep -o RAWSOCK


### Development

Higher level tests are written in Gherkin language and are executed
using [behave](https://behave.readthedocs.io/en/stable/).
[yet-another-runner](https://github.com/aragaer/runner) is used by
these tests.

Unit-tests are implemented in lisp using `prove` package.
