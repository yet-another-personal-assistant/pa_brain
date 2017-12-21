#!/usr/bin/python3
# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4

import atexit
import json
import logging
import os
import shutil
import socket
import sys
import time

from tempfile import mkdtemp
from threading import Thread

from router.routing.runner import Runner


_LOGGER = logging.getLogger(__name__)


class TranslatorServer:

    def __init__(self, path):
        self.running = True
        self.server = None
        self.client = None
        self.path = path

    def run_forever(self):
        self.server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.server.bind(self.path)
        self.server.listen()
        while self.running:
            self.client, _ = self.server.accept()
            while self.running:
                try:
                    sdata = self.client.recv(1024)
                except:
                    break
                if not sdata:
                    break
                data = sdata.decode().strip()
                if not data:
                    continue
                event = json.loads(data)
                if 'command' in event:
                    pass
                else:
                    assert event['text'] is not None
                    event['reply'] = event['text']
                    _LOGGER.info("Translator: %s", event['text'])
                    result = json.dumps(event, ensure_ascii=False)
                    sresult = "{}\n".format(result).encode()
                    self.client.send(sresult)
            self.client.close()

    def stop(self):
        self.running = False
        if self.server is not None:
            self.server.close()
        if self.client is not None:
            self.client.close()

    def drop_client(self):
        if self.client is not None:
            self.client.close()


def _set_up_runner(context):
    app_config_path = os.path.join(context.dir, "modules.yml")
    with open(app_config_path, "w") as app_config:
        app_config.write("brain:\n"
                         "  command: sbcl --noinform --load run.lisp"
                         " --eval '(com.aragaer.pa-brain:main)'\n"
                         "  type: socket\n"
                         "  cwd: .\n")
    context.runner = Runner()
    context.runner.load(app_config_path)


def before_all(context):
    context.dir = mkdtemp()
    atexit.register(shutil.rmtree, context.dir)
    context.tr_socket = os.path.join(context.dir, "tr_socket")
    context.translator = TranslatorServer(context.tr_socket)
    context.tr_thread = Thread(target=context.translator.run_forever, daemon=True)
    context.tr_thread.start()
    logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)
    while not os.path.exists(context.tr_socket):
        _LOGGER.info("waiting for %s", context.tr_socket)
        time.sleep(1)
    _set_up_runner(context)
    context.socket = os.path.join(context.dir, "socket")
    context.user_config_file = os.path.join(context.dir, "config.yml")
    context.user_config = {}
    context.dump = os.path.join(context.dir, "saved")


def before_scenario(context, _):
    context.replies = []


def after_scenario(context, _):
    context.translator.drop_client()
    context.runner.terminate("brain")
    if os.path.exists(context.dump):
        os.unlink(context.dump)
