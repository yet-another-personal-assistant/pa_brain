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
current `pa-brain` implementation.

### Requirements

- [quicklisp](https://www.quicklisp.org/beta/)
- Translator ([pa2human v0.1.0+](https://github.com/aragaer/pa2human) or any other implementation) must be running

### Development

Higher level tests are written in Gherkin language and are executed
using [behave](https://behave.readthedocs.io/en/stable/).
[yet-another-runner](https://github.com/aragaer/runner) is used by
these tests.
