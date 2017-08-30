from tempfile import NamedTemporaryFile
import os.path as op

from django.test import TestCase
from django.core.files import File
from django.conf import settings

from .utils import *


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
