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
from channels.poller import Poller


_LOGGER = logging.getLogger(__name__)


class TranslatorServer:

    def __init__(self, path, translations, messages):
        self.running = True
        self.server = None
        self.client = None
        self.path = path
        self._human2pa = translations['human2pa']
        self._pa2human = translations['pa2human']
        self._messages = messages
        self.poller = Poller()

    def run_forever(self):
        self.server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.server.bind(self.path)
        self.server.listen()
        self.poller.add_server(self.server)
        while self.running:
            for data, channel in self.poller.poll():
                if channel == self.server:
                    _LOGGER.info("Client connected")
                elif data:
                    _LOGGER.debug("Data: %r", data)
                    self._messages.append(data)
                    event = json.loads(data)
                    if 'text' in event:
                        intent = self._human2pa.get(event['text'],
                                                    "unintelligible")
                        _LOGGER.info("Translator: %s->%s",
                                     event['text'], intent)
                        result = {'intent': intent}
                    elif 'intent' in event:
                        text = self._pa2human.get(event['intent'],
                                                  "errored")
                        _LOGGER.info("Translator: %s->%s",
                                     event['intent'], text)
                        result = {'text': text}
                    else:
                        result = {"error": "Either 'intent' or 'text' required"}
                    channel.write(json.dumps(result).encode()+b'\n')

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
    context.translations = {'pa2human':{}, 'human2pa': {}}
    context.tr_messages = []
    context.translator = TranslatorServer(context.tr_socket,
                                          context.translations,
                                          context.tr_messages)
    context.tr_thread = Thread(target=context.translator.run_forever,
                               daemon=True)
    context.tr_thread.start()
    logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)
    while not os.path.exists(context.tr_socket):
        _LOGGER.info("waiting for %s", context.tr_socket)
        time.sleep(1)

    context.runner = Runner()
    context.runner.add("main", command="sbcl --script run.lisp",
                       buffering="line")


def before_scenario(context, _):
    context.last_tr_message = 0
    context.poller = Poller()


def after_scenario(context, _):
    context.translator.drop_client()
    context.tr_messages.clear()
    context.translations['pa2human'].clear()
    context.translations['human2pa'].clear()
    context.poller.close_all()
