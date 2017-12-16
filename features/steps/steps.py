import atexit
import os

import yaml


@given('{module} module is enabled')
def step_impl(context, module):
    if 'modules' not in context.user_config:
        context.user_config['modules'] = []
    context.user_config['modules'].append(module)

@given('the brain is running')
def step_impl(context):
    with open(context.user_config_file, "w") as user_config:
        yaml.dump(context.user_config, user_config)
    context.runner.ensure_running("brain",
                                  with_args=["--socket", context.socket,
                                             "--config", context.user_config_file,
                                             "--saved", context.dump,
                                             "--translator", context.tr_socket],
                                  socket=context.socket)
    atexit.register(context.runner.terminate, "brain")
    context.sink = context.runner.get_sink("brain")    
    context.faucet = context.runner.get_faucet("brain")    

@given('already said hello')
def step_impl(context):
    context.execute_steps('''
    When I say "hello"
    Then pa replies "hello"
    ''')

@when('I say "{phrase}"')
def step_impl(context, phrase):
    context.sink.write({"from": {"media": "behave"}, "text": phrase})


@when('"{event}" event comes')
def step_impl(context, event):
    context.sink.write({"from": {"media": "behave_incoming"}, "intent": event})


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
