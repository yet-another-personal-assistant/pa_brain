# Personal Assistant brain

This is the brain behind my virtual personal assistant. It implements
all the communication scenarios.

### Protocol

Brain accepts messages on its standard input and writes replies to
standard output. Each message is an one-lined json-object. There are
the following types of messages:

- command: command from some other component of PA to this brain instance
- event: an external event sent by some other component of PA
- message: message sent by user

#### Commands

Message with `command` field is considered to be a command from some
other component. Only one command is currently supported:

##### `switch-user`

Change current active user of this brain instance to the user
specified in `'user'` field of the message.

#### Events

Message with `event` field is considere to be an event sent by some
other component. The difference from command is that command is
something that brain should perform internally, while event is
something to what brain should react.

Currently all events are silently discarded.

#### Messages

Message is something sent by user. It should have the following fields:

- `message`: text sent by user or pa
- `from`: object specifying source of this message
- `to`: can be anything

`from` field should be an object containing `user` field. If it is
different from current active user the whole message is silently
discarded.

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
