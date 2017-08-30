import mimetypes
from itertools import repeat

from django.core.exceptions import ValidationError
from django.utils.deconstruct import deconstructible

from .utils import get_file_size


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
    
    The media type of the file is guessed using the `mimetypes` module from
    the Python standard library. This is based purely on the file name. The
    type is made to include common nonstandard types by passing
    `strict=False`.
    
    References:
    https://docs.python.org/3/library/mimetypes.html
    https://www.iana.org/assignments/media-types/media-types.xhtml
    """
    
    def __init__(self, accept, reject=[]):
        self.accept = accept
        self.reject = reject
    
    def __eq__(self, other):
        return self.accept = other.accept and self.reject = other.reject
    
    def __call__(self, file):
        """ `file` should be a path or an object with a `name` attribute. """
        name = getattr(file, 'name', file)
        guessed_type = mimetypes.guess_type(name, strict=False)
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
        for left, right in zip(pattern.split('/'), guessed.split('/')):
            if left not in ('*', right):
                return False
        return True
