import atexit
import logging
import os
import signal
import time

import yaml

from behave import *
from nose.tools import eq_


_LOGGER = logging.getLogger(__name__)


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


@given('"{event}" event happened')
@when('"{event}" event comes')
def step_impl(context, event):
    context.sink.write({"from": {"media": "behave_incoming"}, "event": event})


def timeout(signum, flame):
    raise Exception("timeout")


def _get_reply(context):
    if not context.replies:
        signal.signal(signal.SIGALRM, timeout)
        signal.alarm(1)
        while True:
            try:
                message = context.faucet.read()
            except:
                break
            if message:
                break
        signal.alarm(0)
        _LOGGER.debug("Got message %s", message)
        if message is not None:
            context.replies.extend(message['text'])
    if context.replies:
        result = context.replies.pop(0)
        _LOGGER.info("got reply '%s'", result)
        return result
    _LOGGER.info("got no reply")


@then('pa says "{expected}"')
@then('pa replies "{expected}"')
def step_impl(context, expected):
    eq_(_get_reply(context), expected)


@then('pa says nothing')
def step_impl(context):
    eq_(_get_reply(context), None)


@then('translator gets "{command}" command')
def step_impl(context, command):
    signal.signal(signal.SIGALRM, timeout)
    signal.alarm(1)
    while not context.tr_commands:
        time.sleep(0.01)
    signal.alarm(0)
    eq_(context.tr_commands.pop(0), command)
