import logging
import socket

from behave import *
from channels import SocketChannel

from utils import timeout


@given('the router is started')
def step_impl(context):
    context.router = socket.socket()
    context.router.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)
    context.router.bind(context.router_addr)
    context.router.listen(0)
    context.router_addr = context.router.getsockname()


@then('the application connects to the router')
def step_impl(context):
    with timeout(1):
        client, _ = context.router.accept()
    context.channel = SocketChannel(client, buffering='line')


@when('router restarts')
def step_impl(context):
    context.router.close()
    context.channel.close()
    context.execute_steps('Given the router is started')
