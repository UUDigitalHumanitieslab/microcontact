import os.path as op

import pytest

from django.core.exceptions import ValidationError

from .validators import *

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

MEDIA_TYPE_SCENARIOS = {
    'accept_all': {
        'accept': ['*/*'],
        'reject': [],
        'pass': True,
    },
    'reject_all': {
        'accept': [],
        'reject': [],
        'pass': False,
    },
    'accept_audio': {
        'accept': ['audio/*', 'application/octet-stream'],
        'reject': [],
        'pass': True,
    },
    'reject_audio': {
        'accept': ['*/*'],
        'reject': ['audio/*', 'application/octet-stream'],
        'pass': False,
    },
    'accept_amr': {
        'accept': ['audio/AMR', 'application/octet-stream'],
        'reject': [],
        'pass': True,
    },
    'reject_amr': {
        'accept': ['audio/*'],
        'reject': ['audio/AMR', 'application/octet-stream'],
        'pass': False,
    },
    'mixed_accept_audio': {
        'accept': ['video/*', 'audio/*', 'application/octet-stream', 'text/plain', 'text/csv'],
        'reject': ['video/MPV', 'video/quicktime'],
        'pass': True,
    },
    'mixed_reject_audio': {
        'accept': ['video/*', 'text/plain', 'text/csv'],
        'reject': ['video/MPV', 'video/quicktime', 'audio/*'],
        'pass': False,
    },
    'mixed_accept_amr': {
        'accept': ['video/*', 'text/plain', 'text/csv', 'audio/AMR', 'application/octet-stream'],
        'reject': ['video/MPV', 'video/quicktime'],
        'pass': True,
    },
    'mixed_reject_amr': {
        'accept': ['video/*', 'audio/*', 'text/plain', 'text/csv'],
        'reject': ['video/MPV', 'audio/AMR', 'video/quicktime'],
        'pass': False,
    },
}


@pytest.fixture(
    params=FILE_SIZE_SCENARIOS.values(),
    ids=list(FILE_SIZE_SCENARIOS.keys()),
)
def file_size_fix(request, amr_file):
    return dict(file=amr_file.name, **request.param)


def test_FileSizeValidator(file_size_fix):
    validate = FileSizeValidator(file_size_fix['min'], file_size_fix['max'])
    if file_size_fix['pass']:
        assert validate(file_size_fix['file']) is None
    else:
        with pytest.raises(ValidationError):
            validate(file_size_fix['file'])


@pytest.fixture(
    params=MEDIA_TYPE_SCENARIOS.values(),
    ids=list(MEDIA_TYPE_SCENARIOS.keys()),
)
def media_type_fix(request, amr_file):
    return dict(file=amr_file.name, **request.param)


def test_MediaTypeValidator(media_type_fix):
    validate = MediaTypeValidator(
        media_type_fix['accept'],
        media_type_fix['reject'],
    )
    if media_type_fix['pass']:
        assert validate(media_type_fix['file']) is None
    else:
        with pytest.raises(ValidationError):
            validate(media_type_fix['file'])
