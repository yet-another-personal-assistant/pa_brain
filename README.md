# Personal Assistant brain

This is the brain behind my virtual personal assistant. It implements
all the communication scenarios.

## Active user/channel

Single instance of the brain only handles a single user. See
`switch-user` command below.

For active user there is a single "active channel". When brain reacts
to a message or event it uses this "active channel" to fill the
`channel` field in `to` object.

## Protocol

Brain accepts messages on its standard input and writes replies to
standard output. Each message is an one-lined json-object. There are
the following types of messages:

- command: command from some other component of PA to this brain instance
- event: an external event sent by some other component of PA
- message: message sent by user

### Commands

Message with `command` field is considered to be a command from some
other component. The following commands are supported:

#### `switch-user`

Change current active user of this brain instance to the user
specified in `'user'` field of the message.

#### `say`

Sends message specified in `'text'` field of the message to the
current user through the current active channel.

### Events

Message with `event` field is considere to be an event sent by some
other component. The difference from command is that command is
something that brain should perform internally, while event is
something to what brain should react. The following events are
supported:

#### `presence`

Sets the active channel to the same channel that is the source of this
message.

#### `new-day`

Queues/Sends `'good morning'` message to active user.

### Messages

Message is something sent by user or to user. It should have the
following fields:

- `message`: text sent by user or pa
- `from`: object specifying source of this message
- `to`: object specifying destination of this message

If message is received by the brain `from` field should be an object
containing `user` field. If it is different from current active user
the whole message is silently discarded.

Messages sent by brain have `from` equal to `{"user": "niege",
"channel": "brain"}`. If message is a reaction to user message `to` is
equal to `from` of that user message. Otherwise the `channel` in `to`
object is set to current active channel.

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
