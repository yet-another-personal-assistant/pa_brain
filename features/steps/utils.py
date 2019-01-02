import json
import signal

from contextlib import contextmanager
from nose.tools import eq_


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


def compare_json(line, expected):
    try:
        message = json.loads(line)
    except (TypeError, json.JSONDecodeError):
        print("[{}] is not a json string".format(line))
        raise
    expected = json.loads(expected)
    eq_(message, expected)

