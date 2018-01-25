import pytest


@pytest.fixture
def tmp_media_root(settings, tmpdir):
    """ Set a temporary MEDIA_ROOT. """
    settings.MEDIA_ROOT = str(tmpdir)


@pytest.fixture
def app_data(tmp_media_root, db):
    """ Enable use of the database together with a temporary MEDIA_ROOT. """
    pass
