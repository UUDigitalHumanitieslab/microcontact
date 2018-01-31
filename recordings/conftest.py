import os.path as op
from itertools import cycle

import pytest

from django.core.files import File

from .models import *

HERE = op.dirname(__file__)
TESTCASE_DIR = op.join(HERE, 'testcases')

PLACES_KWARGS = (
    {'placeID': 'x4', 'name': 'Rivendell', 'latitude': 10, 'longitude': -2},
    {'placeID': 'b9', 'name': 'Barad-Dur', 'latitude': -3, 'longitude': 6},
    {'placeID': 'a6', 'name': 'Tharbad', 'latitude': 5, 'longitude': -7},
    {'placeID': 'v3', 'name': 'Minas Morgul', 'latitude': -5, 'longitude': 4},
)


@pytest.fixture
def testcase_dir():
    """ Returns the path to the directory containing testcase files. """
    return TESTCASE_DIR


@pytest.fixture
def mp3_file(testcase_dir):
    """ Return the mp3 file from the testcases directory. """
    return open(op.join(testcase_dir, 'speech.mp3'), mode='rb')


@pytest.fixture
def amr_file(testcase_dir):
    """ Return the amr file from the testcases directory. """
    return open(op.join(testcase_dir, 'speech.amr'), mode='rb')


@pytest.fixture
def audio_files(mp3_file, amr_file):
    """ Returns all of the testcase audio files. """
    return (amr_file, mp3_file)


def insert_into_db(items, model):
    """ Save each of the `items` into the database. """
    for item in items:
        item.save()
    return model.objects.all()


def insertable(model):
    """
        Return a fixture decorator adding an _in_db version.
        
        Given a fixture and its name, generate a second fixture which has
        the same name with _in_db appended. This fixture returns the same
        set of model instances, except that they are already saved in the
        database. The instances are automatically removed from the database
        on teardown.
    """
    def decorate(fixture):
        name = fixture.__name__
        name_in_db = name + '_in_db'
        @pytest.fixture(name=name_in_db)
        def fixture_in_db(request, app_data):
            return insert_into_db(request.getfixturevalue(name), model)
        globals()[name_in_db] = fixture_in_db
        return fixture  # unchanged
    return decorate


@insertable(Dialect)
@pytest.fixture
def dialects():
    """ Return Dialect instances which haven't been saved yet. """
    return (
        Dialect(dialect='Elvish', color='#fff'),
        Dialect(dialect='Orkish', color='#000'),
    )


@insertable(Country)
@pytest.fixture
def countries():
    """ Return Country instances which haven't been saved yet. """
    return (
        Country(name='Eriador', code='ER'),
        Country(name='Mordor', code='MO'),
    )


@insertable(Place)
@pytest.fixture
def places(countries_in_db):
    """ Return Place instances which haven't been saved yet. """
    return tuple(Place(country=country, **kwargs)
        for country, kwargs in zip(cycle(countries_in_db), PLACES_KWARGS)
    )


@insertable(Recording)
@pytest.fixture
def recordings(dialects_in_db, places_in_db, audio_files):
    """ Return Recording instances which haven't been saved yet. """
    return (
        Recording(dialect=dialects_in_db[0], place=places_in_db[0], recording=File(audio_files[0])),
        Recording(dialect=dialects_in_db[1], place=places_in_db[1], recording=File(audio_files[1])),
    )
