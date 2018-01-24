from tempfile import TemporaryFile, NamedTemporaryFile
import os.path as op
import os

from django.test import TestCase
from django.core.files import File
from django.conf import settings

from conftest import use_adapted_fixtures
from .utils import *

TEST_FILE = 'speech.amr'
TEST_FILE_SIZE = 8838


class GetAbsolutePathTestCase(TestCase):
    """ Using a unittest-style TestCase because of Django settings. """

    def test_get_from_relative(self):
        tail = op.relpath(__file__)
        assert get_absolute_path(tail) == __file__
    
    def test_get_from_absolute(self):
        assert get_absolute_path(__file__) == __file__
    
    def test_get_from_django_File(self):
        with NamedTemporaryFile(dir=settings.MEDIA_ROOT) as temp:
            django_file = File(temp)
            absolute_path = get_absolute_path(django_file)
            assert op.isabs(absolute_path)
            assert op.isfile(absolute_path)


@use_adapted_fixtures('testcase_dir')
class GetFileSizeTestCase(TestCase):
    """ Using a unittest-style TestCase because of Django settings. """
    
    def setUp(self):
        self.full_path = op.abspath(op.join(self.testcase_dir, TEST_FILE))
    
    def test_get_from_string(self):
        assert get_file_size(self.full_path) == TEST_FILE_SIZE
    
    def test_get_from_named_object(self):
        file_object = File(open(self.full_path))
        assert get_file_size(file_object) == TEST_FILE_SIZE
    
    def test_get_from_unnamed_object(self):
        data = b'123456789'
        seek_pos = 2
        with TemporaryFile() as temp:
            temp.write(data)
            temp.seek(seek_pos, os.SEEK_SET)
            assert get_file_size(temp) == len(data)
            assert temp.tell() == seek_pos
