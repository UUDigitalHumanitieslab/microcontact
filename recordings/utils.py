import os
import os.path as op

from django.conf import settings
from django.core.files import File


def get_absolute_path(file):
    """ Return the absolute path for a file name or a django File object. """
    if isinstance(file, File):
        return op.abspath(op.join(settings.MEDIA_ROOT, file.name))
    return op.abspath(file)


def get_file_size(file):
    """ Return the file size in bytes for a path or a file-like object. """
    try:
        # the clean way
        return op.getsize(get_absolute_path(file))
    except:
        if hasattr(file, 'seek') and hasattr(file, 'tell'):
            # file-like object without a name
            # algo taken from https://stackoverflow.com/a/19079887
            old_position = file.tell()
            file.seek(0, os.SEEK_END)
            size = file.tell()
            file.seek(old_position, os.SEEK_SET)
            return size
        else:
            # try-branch failed for a different reason
            raise
