from tempfile import TemporaryFile, NamedTemporaryFile
import os.path as op
import os

import pytest

from django.core.files import File

from .utils import *

TEST_FILE_SIZE = 8838


def test_get_absolute_path_from_relative():
    tail = op.relpath(__file__)
    assert get_absolute_path(tail) == __file__


def test_get_absolute_path_from_absolute():
    assert get_absolute_path(__file__) == __file__


def test_get_absolute_path_from_django_File(tmp_media_root, settings):
    with NamedTemporaryFile(dir=settings.MEDIA_ROOT) as temp:
        django_file = File(temp)
        absolute_path = get_absolute_path(django_file)
        assert op.isabs(absolute_path)
        assert op.isfile(absolute_path)


def test_get_file_size_from_string(amr_file):
    full_path = op.abspath(amr_file.name)
    assert get_file_size(full_path) == TEST_FILE_SIZE


def test_get_file_size_from_named_object(amr_file):
    file_object = File(amr_file)
    assert get_file_size(file_object) == TEST_FILE_SIZE


def test_get_file_size_from_unnamed_object():
    data = b'123456789'
    seek_pos = 2
    with TemporaryFile() as temp:
        temp.write(data)
        temp.seek(seek_pos, os.SEEK_SET)
        assert get_file_size(temp) == len(data)
        assert temp.tell() == seek_pos
