import os.path as op

import pytest

HERE = op.dirname(__file__)
TESTCASE_DIR = op.join(HERE, 'testcases')


@pytest.fixture
def testcase_dir():
    """ Returns the path to the directory containing testcase files. """
    return TESTCASE_DIR
