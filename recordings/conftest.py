import os.path as op

import pytest

HERE = op.dirname(__file__)
TESTCASE_DIR = op.join(HERE, 'testcases')


@pytest.fixture
def testcase_dir():
    """ Returns the path to the directory containing testcase files. """
    return TESTCASE_DIR


@pytest.fixture
def mp3_file(testcase_dir):
    """ Return the mp3 file from the testcases directory. """
    return open(op.join(testcase_dir, 'speech.mp3'), mode='rb')


@pytest.fixture
def amr_file(testcase_dir):
    """ Return the amr file from the testcases directory. """
    return open(op.join(testcase_dir, 'speech.amr'), mode='rb')
