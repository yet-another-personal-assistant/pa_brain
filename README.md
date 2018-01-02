# Personal Assistant brain

## Command-line arguments

- --socket <path> - path to a socket file
- --config <path> - path to a configuration file
- --saved <path> - path to a saved state dump
- --translator <path> - path to a translator service socket

## Configuration

Configuration is a yaml file. The following sections will be checked:

### Modules

Should be a list of modules to be enabled. Currently the following optional modules exist:
- _admin_

    This module allows administrative commands:
    - `reload phrases`

    Other commands will be added later
- _japanese_

    This module enables the tracking of daily japanese study.
- _maki-uchi_

    This module enables the tracking of daily maki-uchi exercises. If this module is enabled, maki-uchi binary must be located at $HOME/Projects/maki-uchi/maki-uchi. Also there should be 'maki-uchi' entry in the configuration that points to the maki-uchi log file.

### Telegram

Telegram ID of the brain owner.

If message "media" is "incoming" (see below for message format), response is sent to the telegram user with the specified ID.

## Message format

Each message is a single-line JSON (no newlines must be within messages) ending with a newline.
Received message may contain the following fields:

- `from`

  **Mandatory**

  Used to correctly fill "to" field of the response message. Must contain the "media" field.
  - `telegram`

    Must also supply "id" field. "to" field is set to `telegram` and additional "chat_id" field is added with value of "id" field from "from".
  - `incoming`

    "to" field is set to `telegram` and "chat_id" field is set to a value of telegram ID from the configuration file.
  - _other_

    "to" field is set to value of the "media" field
- `intent`

  Command or list of commands to interpret.
- `text`

  String or list of strings entered by user. Ignored if "intent" field is already present. Each string is passed to the translator module and the result is interpreted as a command.
- `event`

  Used to pass internal events.
Message sent as a response will contain the following fields:
- `from`

  Set to `pa`
- `text`

  List of one or more human-readable messages.
- `to`

  Filled depending on "from"->"media" of original message.
