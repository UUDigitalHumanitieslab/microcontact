import os.path as op

import pytest

from django.core.exceptions import ValidationError

from .validators import *

TEST_FILE = op.join('recordings', 'testcases', 'speech.amr')
TEST_FILE_SIZE = 8838

FILE_SIZE_SCENARIOS = {
    'allpass': {
        'min': None,
        'max': None,
        'pass': True,
    },
    'low_pass': {
        'min': TEST_FILE_SIZE,
        'max': None,
        'pass': True,
    },
    'low_reject': {
        'min': TEST_FILE_SIZE + 1,
        'max': None,
        'pass': False,
    },
    'high_pass': {
        'min': None,
        'max': TEST_FILE_SIZE,
        'pass': True,
    },
    'high_reject': {
        'min': None,
        'max': TEST_FILE_SIZE - 1,
        'pass': False,
    },
    'narrow_pass': {
        'min': TEST_FILE_SIZE,
        'max': TEST_FILE_SIZE,
        'pass': True,
    },
    'narrow_reject_low': {
        'min': TEST_FILE_SIZE + 1,
        'max': TEST_FILE_SIZE + 1,
        'pass': False,
    },
    'narrow_reject_high': {
        'min': TEST_FILE_SIZE - 1,
        'max': TEST_FILE_SIZE - 1,
        'pass': False,
    },
}


@pytest.fixture(
    params=FILE_SIZE_SCENARIOS.values(),
    ids=list(FILE_SIZE_SCENARIOS.keys()),
)
def file_size_fix(request):
    return dict(file=TEST_FILE, **request.param)


def test_FileSizeValidator(file_size_fix):
    validate = FileSizeValidator(file_size_fix['min'], file_size_fix['max'])
    if file_size_fix['pass']:
        assert validate(file_size_fix['file']) is None
    else:
        with pytest.raises(ValidationError):
            validate(file_size_fix['file'])
