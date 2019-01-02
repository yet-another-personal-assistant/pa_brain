import logging
import socket

from behave import *

from utils import compare_json, timeout


_LOGGER = logging.getLogger(__name__)


@given("the application is started with alternative translator address")
def step_impl(context):
    if context.alt_serv is None:
        try:
            sock = socket.create_connection(context.alt_sockaddr)
            sock.close()
            context.scenario.skip("Alternative translator address is taken by something")
        except:
            pass
    context.add_cleanup(context.runner.terminate, "main")
    context.runner.start("main", with_args=["--translator", '{}:{}'.format(*context.alt_sockaddr)])
    context.channel = context.runner.get_channel("main")
    context.poller.register(context.channel)


@given("alternative translator is running")
@when("alternative translator becomes active")
def step_impl(context):
    context.alt_serv = socket.socket()
    context.alt_serv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)
    context.alt_serv.bind(context.alt_sockaddr)
    context.alt_serv.listen()
    context.add_cleanup(context.alt_serv.close)


@then('the application connects to alternative translator')
def step_impl(context):
    with timeout(1):
        context.alt_client, _ = context.alt_serv.accept()


@then('alternative translator receives the following request')
def step_impl(context):
    with timeout(1):
        line = context.alt_client.recv(1024)
    _LOGGER.debug("Alt translator got [%s]", line)
    compare_json(line.decode(), context.text)
    context.last_tr_message += 1


@when('alternative translator goes offline')
def step_impl(context):
    context.alt_serv.close()
