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

from runner import Runner


_LOGGER = logging.getLogger(__name__)


class TranslatorServer:

    def __init__(self, path, messages):
        self.running = True
        self.server = None
        self.client = None
        self.path = path
        self._messages = messages

    def run_forever(self):
        self.server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.server.bind(self.path)
        self.server.listen()
        while self.running:
            self.client, _ = self.server.accept()
            _LOGGER.info("Client connected")
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
                self._messages.append(data)
                event = json.loads(data)
                if 'text' in event:
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


def before_all(context):
    context.dir = mkdtemp()
    atexit.register(shutil.rmtree, context.dir)
    context.tr_socket = os.path.join(context.dir, "tr_socket")
    context.tr_messages = []
    context.translator = TranslatorServer(context.tr_socket, context.tr_messages)
    context.tr_thread = Thread(target=context.translator.run_forever, daemon=True)
    context.tr_thread.start()
    logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)
    while not os.path.exists(context.tr_socket):
        _LOGGER.info("waiting for %s", context.tr_socket)
        time.sleep(1)

    context.runner = Runner()
    context.runner.update_config({"main": {"command": "sbcl --script run.lisp --quit", "type": "stdio"}})


def before_scenario(context, _):
    context.replies = []


def after_scenario(context, _):
    context.translator.drop_client()
    context.tr_messages.clear()
