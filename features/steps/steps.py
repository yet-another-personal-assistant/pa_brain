import atexit
import os


def _write_user_config(context, config_text):
    with open(context.user_config, "w") as user_config:
        user_config.write(config_text)


@given('the brain is running')
def step_impl(context):
    atexit.register(context.runner.terminate, "brain")
    _write_user_config(context, "")
    context.runner.ensure_running("brain",
                                  with_args=["--socket", context.socket,
                                             "--config", context.user_config,
                                             "--saved", context.dump,
                                             "--translator", context.tr_socket],
                                  socket=context.socket)
    context.sink = context.runner.get_sink("brain")    
    context.faucet = context.runner.get_faucet("brain")    


@when('I say "{phrase}"')
def step_impl(context, phrase):
    context.sink.write({"from": {"media": "behave"}, "text": phrase})


@then('pa says "{expected}"')
@then('pa replies "{expected}"')
def step_impl(context, expected):
    if not context.replies:
        while True:
            message = context.faucet.read()
            if message:
                break
        context.replies.extend(message['text'])
    
    reply = context.replies.pop(0)
    if expected != reply:
        raise Exception("Expected '{}' got '{}'".format(expected, reply))
