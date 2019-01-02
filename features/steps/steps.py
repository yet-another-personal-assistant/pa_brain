import logging

from time import sleep

from behave import *
from nose.tools import eq_, ok_

from utils import compare_json, timeout


_LOGGER = logging.getLogger(__name__)


def _terminate(context, alias):
    try:
        context.runner.terminate(alias)
    except KeyError:
        _LOGGER.debug("%s was not started", alias)


def _await_reply(context):
    for data, channel in context.poller.poll(1):
        _LOGGER.debug("Got data %r from channel %s", data, channel)
        if channel == context.channel:
            _LOGGER.debug("Returning %r", data)
            return data
        else:
            _LOGGER.debug("Discarding %r", data)


@given('the application is started')
@when(u'I start the application')
def step_impl(context):
    if 'tcp_translator' in context.tags:
        sockname = '{}:{}'.format(*context.translator.addr)
    else:
        sockname = context.tr_socket
    context.add_cleanup(_terminate, context, "main")
    context.runner.start("main", with_args=["--translator", sockname])
    context.channel = context.runner.get_channel("main")
    context.poller.register(context.channel)


@when(u'I send the following line')
def step_impl(context):
    context.channel.write(context.text.encode(), b'\n')


@then(u'I receive the following line')
def step_impl(context):
    line = _await_reply(context)
    ok_(line is not None)
    compare_json(line, context.text)


@then(u'translator receives the following request')
def step_impl(context):
    with timeout(1):
        while len(context.tr_messages) == context.last_tr_message:
            sleep(0.1)
    line = context.tr_messages[context.last_tr_message]
    _LOGGER.debug("Translator got [%s]", line)
    compare_json(line, context.text)
    context.last_tr_message += 1


@given(u'the translation from {f} to {t}')
def step_impl(context, f, t):
    dict_name = f+'2'+t
    translations = context.translations[dict_name]
    for row in context.table:
        translations[row[0]] = row[1]


@then("I don't get any reply")
def step_impl(context):
    line = _await_reply(context)
    if line is not None:
        print("Got a message when no message is expected: ", line)
        assert False


@given("current user is {user}")
def step_impl(context, user):
    context.execute_steps('''
    When I send the following line:
       """
       {"command": "switch-user", "user": "%s"}
       """
    ''' % user)
