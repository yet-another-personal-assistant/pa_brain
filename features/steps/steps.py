import json
import logging
import signal

from contextlib import contextmanager
from time import sleep

from behave import *
from nose.tools import eq_


_LOGGER = logging.getLogger(__name__)


def _terminate(context, alias):
    try:
        context.runner.terminate(alias)
    except KeyError:
        _LOGGER.debug("%s was not started", alias)


class TimeoutException(Exception):
    pass


def _timeout(signum, flame):
    raise TimeoutException()


@contextmanager
def timeout(timeout):
    signal.signal(signal.SIGALRM, _timeout)
    signal.setitimer(signal.ITIMER_REAL, timeout)
    try:
        yield
    finally:
        signal.setitimer(signal.ITIMER_REAL, 0)


def _await_reply(context):
    with timeout(1):
        while True:
            message = context.channel.read()
            if message:
                return message


@given('the application is started')
@when(u'I start the application')
def step_impl(context):
    context.add_cleanup(_terminate, context, "main")
    context.runner.start("main", with_args=["--translator", context.tr_socket])
    context.channel = context.runner.get_channel("main")


@when(u'I send the following line')
def step_impl(context):
    context.channel.write(context.text.encode())
    context.channel.write(b'\n')


def _compare_json(line, expected):
    try:
        message = json.loads(line)
    except json.JSONDecodeError:
        print("[{}] is not a json string".format(line))
        raise
    expected = json.loads(expected)
    eq_(message, expected)


@then(u'I receive the following line')
def step_impl(context):
    line = _await_reply(context)
    _compare_json(line, context.text)


@then(u'translator receives the following request')
def step_impl(context):
    with timeout(1):
        while len(context.tr_messages) == context.last_tr_message:
            sleep(0.1)
    line = context.tr_messages[context.last_tr_message]
    _compare_json(line, context.text)
    context.last_tr_message += 1

@given(u'the translation from {f} to {t}')
def step_impl(context, f, t):
    dict_name = f+'2'+t
    translations = context.translations[dict_name]
    for row in context.table:
        translations[row[0]] = row[1]

@then("I don't get any reply")
def step_impl(context):
    try:
        line = _await_reply(context)
        print("Got a message when no message is expected: ", line)
        assert False
    except TimeoutException as ex:
        pass


@given("current user is {user}")
def step_impl(context, user):
    context.execute_steps('''
    When I send the following line:
       """
       {"command": "switch-user", "user": "%s"}
       """
    ''' % user)
