from itertools import repeat
import io

import magic

from django.core.exceptions import ValidationError
from django.utils.deconstruct import deconstructible

from .utils import get_file_size

SAMPLE_SIZE = 4096


@deconstructible  # to facilitate migrations
class FileSizeValidator(object):
    """ Checks that the size of a file meets the given constraints. """
    
    def __init__(self, min_size=None, max_size=None):
        """ `min_size` and `max_size` are file sizes in bytes. """
        if min_size is not None and max_size is not None:
            assert min_size <= max_size
        self.min = min_size
        self.max = max_size
    
    def __eq__(self, other):
        return self.min == other.min and self.max == other.max
    
    def __call__(self, file):
        """ `file` can be a path or a Pythonic file-like object. """
        size = get_file_size(file)
        if self.max and size > self.max:
            raise ValidationError(
                '%(actual)d bytes found but only %(maximum)d permitted',
                params={
                    'actual': size,
                    'maximum': self.max,
                },
            )
        if self.min and size < self.min:
            raise ValidationError(
                '%(actual)d bytes found but at least %(minimum)d required',
                params={
                    'actual': size,
                    'minimum': self.min,
                },
            )


@deconstructible  # to facilitate migrations
class MediaTypeValidator(object):
    """
    Checks that the media type of a file is within a permitted set of types.
    
    Media types are better known under their former name, MIME types. The
    `accept` and `reject` parameters each take an iterable of media types,
    where `accept` must be nonempty. Globbing patterns such as 'audio/*' 
    are also allowed. The validator first checks that the media type of the
    file matches at least one pattern or type in `accept`. If this check
    succeeds, it then verifies that it does not match any pattern or type
    in `reject`. If you wish to accept anything except for a small set of
    types, you can pass '*/*' as the first and only pattern in `accept`.
    
    The media type of the file is guessed using the python-magic package.
    It relies on libmagic internally. Recent versions of libmagic have a
    bug, that cause it to report 'application/octet-stream' as the type
    for many less-common media file formats (such as AMR audio). If you
    wish to broadly accept such types, you can safely add
    'application/octet-stream' as a fallback to the accepted types;
    executable files (which may be malware) get different types, such as
    'application/x-executable'.
    
    References:
    https://github.com/ahupp/python-magic
    https://www.iana.org/assignments/media-types/media-types.xhtml
    """
    
    def __init__(self, accept, reject=[]):
        self.accept = accept
        self.reject = reject
    
    def __eq__(self, other):
        return self.accept == other.accept and self.reject == other.reject
    
    def __call__(self, file):
        """ `file` should be a path or a file-like object. """
        if hasattr(file, 'read'):
            position = file.tell()
            guessed_type = magic.from_buffer(file.read(SAMPLE_SIZE), mime=True)
            file.seek(position)  # this prevents ugly side effects
        else:
            guessed_type = magic.from_file(file, mime=True)
        guessed_type = guessed_type.lower() if guessed_type else 'unknown'
        if not any(map(self.match, self.accept, repeat(guessed_type))):
            raise ValidationError(
                '%(found)s is not included in the set of accepted types',
                params={'found': guessed_type},
            )
        if any(map(self.match, self.reject, repeat(guessed_type))):
            raise ValidationError(
                '%(found)s is not included in the set of accepted types',
                params={'found': guessed_type},
            )
    
    @staticmethod
    def match(pattern, guessed):
        """
        Return True if media type `guessed` matches `pattern`, False otherwise.
        
        `guessed` should be fully qualified media type such as 'audio/mpeg'.
        `pattern` may contain wildcards, for example 'audio/*' or even '*/*'.
        """
        for left, right in zip(pattern.split('/'), guessed.split('/')):
            if left.lower() not in ('*', right):
                return False
        return True
