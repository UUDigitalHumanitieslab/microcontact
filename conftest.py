from itertools import repeat
import sys

import pytest


def adapt_fixture(name, module):
    """ Adapt a pytest fixture for use with unittest and return the new name."""
    adapted_name = 'instance_' + name
    @pytest.fixture(name=adapted_name)
    def adapted_fixture(request):
        value = request.getfixturevalue(name)
        setattr(request.instance, name, value)
    setattr(sys.modules[module], adapted_name, adapted_fixture)
    return adapted_name


def use_adapted_fixtures(*args):
    """ Mixes pytest fixtures into a unittest/Django TestCase instance. """
    def wrap(cls):
        adapted_names = map(adapt_fixture, args, repeat(cls.__module__))
        return pytest.mark.usefixtures(*adapted_names)(cls)
    return wrap
