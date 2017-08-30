import os
import os.path as op

from django.conf import settings
from django.core.files import File


def get_absolute_path(file):
    """ Return the absolute path for a file name or a django File object. """
    if isinstance(file, File):
        return op.abspath(op.join(settings.MEDIA_ROOT, file.name))
    return op.abspath(file)
