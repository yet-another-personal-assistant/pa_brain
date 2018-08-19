import json
import logging
import signal

from behave import *
from nose.tools import eq_


_LOGGER = logging.getLogger(__name__)


def _terminate(context, alias):
    try:
        context.runner.terminate(alias)
    except KeyError:
        _LOGGER.debug("%s was not started", alias)


def _timeout(signum, flame):
    raise Exception("timeout")


def _await_reply(context):
    signal.signal(signal.SIGALRM, _timeout)
    signal.alarm(1)
    while True:
        if '\n' in context.replies:
            result, context.replies = context.replies.split("\n", 1)
            signal.alarm(0)
            return result
        try:
            message = context.channel.read()
        except:
            break
        if message:
            context.replies += message.decode()
    signal.alarm(0)
    _LOGGER.info("Waited got only [%s]", context.replies)


@when(u'I start the application')
def step_impl(context):
    context.add_cleanup(_terminate, context, "main")
    context.runner.start("main")
    context.channel = context.runner.get_channel("main")
    context.replies = ""


@when(u'I send the following line')
def step_impl(context):
    context.channel.write(context.text.encode())
    context.channel.write(b'\n')


@then(u'I receive the following line')
def step_impl(context):
    line = _await_reply(context)
    try:
        message = json.loads(line)
    except json.JSONDecodeError:
        print("[{}] is not a json string".format(line))
        raise
    expected = json.loads(context.text)
    eq_(message, expected)
