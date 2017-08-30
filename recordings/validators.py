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
