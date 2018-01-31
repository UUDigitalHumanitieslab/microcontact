import pytest

from django.core.files import File

from .signals import *
from .models import Recording


def test_standardize_filename(dummy):
    dummy.id = 3
    assert standardize_filename(dummy, 'banana.mp3') == \
        ('microcontact_0000003.mp3', '.mp3')
    assert standardize_filename(dummy, 'banana.m4a') == \
        ('microcontact_0000003.m4a', '.m4a')
    assert standardize_filename(dummy, 'banana.mp4') == \
        ('microcontact_0000003.mp4', '.mp4')
    assert standardize_filename(dummy, 'banana.amr') == \
        ('microcontact_0000003.amr', '.amr')


@pytest.fixture
def blank_web_safe(dialects_in_db, places_in_db, mp3_file):
    return Recording(
        dialect=dialects_in_db[0],
        place=places_in_db[0],
        recording=File(mp3_file),
    )


@pytest.fixture
def blank_convertible(dialects_in_db, places_in_db, amr_file):
    return Recording(
        dialect=dialects_in_db[0],
        place=places_in_db[0],
        recording=File(amr_file),
    )


@pytest.fixture
def web_safe_in_db(blank_web_safe):
    blank_web_safe.save()
    return blank_web_safe


@pytest.fixture
def converted_in_db(blank_convertible):
    blank_convertible.save()
    return blank_convertible


def test_save_blank_web_safe_rename(blank_web_safe, mp3_file):
    assert blank_web_safe.recording.name == mp3_file.name
    blank_web_safe.save()
    assert op.basename(blank_web_safe.recording.name) == op.basename(standardize_filename(blank_web_safe, mp3_file.name)[0])


def test_save_blank_web_safe_no_alias(blank_web_safe):
    assert blank_web_safe.recording_web == ''
    blank_web_safe.save()
    assert blank_web_safe.recording_web == ''


def test_save_no_change_no_uf_web_safe(web_safe_in_db):
    assert isinstance(web_safe_in_db, Recording)
    original_name = web_safe_in_db.recording.name
    original_file = web_safe_in_db.recording.file
    web_safe_in_db.save()
    assert web_safe_in_db.recording.name == original_name
    assert web_safe_in_db.recording.file == original_file
    assert web_safe_in_db.recording_web == ''


def test_save_no_change_uf_web_safe(web_safe_in_db):
    assert isinstance(web_safe_in_db, Recording)
    original_name = web_safe_in_db.recording.name
    original_file = web_safe_in_db.recording.file
    web_safe_in_db.save(update_fields=())
    assert web_safe_in_db.recording.name == original_name
    assert web_safe_in_db.recording.file == original_file
    assert web_safe_in_db.recording_web == ''


def test_save_arbitrary_change_no_uf_web_safe(web_safe_in_db):
    original_name = web_safe_in_db.recording.name
    original_file = web_safe_in_db.recording.file
    web_safe_in_db.status = Recording.REVIEWED
    web_safe_in_db.public = True
    web_safe_in_db.name = 'Elrond'
    web_safe_in_db.save()
    assert web_safe_in_db.recording.name == original_name
    assert web_safe_in_db.recording.file == original_file
    assert web_safe_in_db.recording_web == ''


def test_save_arbitrary_change_uf_web_safe(web_safe_in_db):
    original_name = web_safe_in_db.recording.name
    original_file = web_safe_in_db.recording.file
    web_safe_in_db.status = Recording.REVIEWED
    web_safe_in_db.public = True
    web_safe_in_db.name = 'Elrond'
    web_safe_in_db.save(update_fields=('status', 'public', 'name'))
    assert web_safe_in_db.recording.name == original_name
    assert web_safe_in_db.recording.file == original_file
    assert web_safe_in_db.recording_web == ''


def test_save_file_change_no_uf_web_safe_to_web_safe(web_safe_in_db, mp3_file):
    original_name = web_safe_in_db.recording.name
    original_file = web_safe_in_db.recording.file
    web_safe_in_db.recording = File(mp3_file)
    web_safe_in_db.save()
    assert web_safe_in_db.recording.name == original_name
    assert web_safe_in_db.recording.file != original_file
    assert web_safe_in_db.recording_web == ''
    assert op.basename(web_safe_in_db.recording_original_name) == op.basename(mp3_file.name)


def test_save_file_change_uf_web_safe_to_web_safe(web_safe_in_db, mp3_file):
    original_name = web_safe_in_db.recording.name
    original_file = web_safe_in_db.recording.file
    web_safe_in_db.recording = File(mp3_file)
    web_safe_in_db.save(update_fields=('recording',))
    assert web_safe_in_db.recording.name == original_name
    assert web_safe_in_db.recording.file != original_file
    assert web_safe_in_db.recording_web == ''
    assert op.basename(web_safe_in_db.recording_original_name) == op.basename(mp3_file.name)


def test_save_file_change_no_uf_web_safe_to_converted(web_safe_in_db, amr_file):
    original_name = web_safe_in_db.recording.name
    original_file = web_safe_in_db.recording.file
    web_safe_in_db.recording = File(amr_file)
    web_safe_in_db.save()
    assert web_safe_in_db.recording.name != original_name
    assert op.splitext(web_safe_in_db.recording.name)[0] == op.splitext(original_name)[0]
    assert web_safe_in_db.recording.file != original_file
    assert web_safe_in_db.recording_web.name == original_name
    assert op.basename(web_safe_in_db.recording_original_name) == op.basename(amr_file.name)


def test_save_file_change_uf_web_safe_to_converted(web_safe_in_db, amr_file):
    original_name = web_safe_in_db.recording.name
    original_file = web_safe_in_db.recording.file
    web_safe_in_db.recording = File(amr_file)
    web_safe_in_db.save(update_fields=('recording',))
    assert web_safe_in_db.recording.name != original_name
    assert op.splitext(web_safe_in_db.recording.name)[0] == op.splitext(original_name)[0]
    assert web_safe_in_db.recording.file != original_file
    assert web_safe_in_db.recording_web.name == original_name
    assert op.basename(web_safe_in_db.recording_original_name) == op.basename(amr_file.name)


def test_save_blank_convertible_rename(blank_convertible, amr_file):
    assert blank_convertible.recording.name == amr_file.name
    blank_convertible.save()
    assert op.basename(blank_convertible.recording.name) == op.basename(standardize_filename(blank_convertible, amr_file.name)[0])


def test_save_blank_convertible_conversion(blank_convertible):
    assert blank_convertible.recording_web == ''
    blank_convertible.save()
    web_name, web_extension = op.splitext(blank_convertible.recording_web.name)
    assert web_name == op.splitext(blank_convertible.recording.name)[0]
    assert web_extension == '.mp3'


def test_save_no_change_no_uf_converted(converted_in_db):
    assert isinstance(converted_in_db, Recording)
    original_name = converted_in_db.recording.name
    original_file = converted_in_db.recording.file
    original_web_name = converted_in_db.recording_web.name
    original_web_file = converted_in_db.recording_web.file
    converted_in_db.save()
    assert converted_in_db.recording.name == original_name
    assert converted_in_db.recording.file == original_file
    assert converted_in_db.recording_web.name == original_web_name


def test_save_no_change_uf_converted(converted_in_db):
    assert isinstance(converted_in_db, Recording)
    original_name = converted_in_db.recording.name
    original_file = converted_in_db.recording.file
    original_web_name = converted_in_db.recording_web.name
    original_web_file = converted_in_db.recording_web.file
    converted_in_db.save(update_fields=())
    assert converted_in_db.recording.name == original_name
    assert converted_in_db.recording.file == original_file
    assert converted_in_db.recording_web.name == original_web_name
    assert converted_in_db.recording_web.file == original_web_file


def test_save_arbitrary_change_no_uf_converted(converted_in_db):
    original_name = converted_in_db.recording.name
    original_file = converted_in_db.recording.file
    original_web_name = converted_in_db.recording_web.name
    original_web_file = converted_in_db.recording_web.file
    converted_in_db.status = Recording.REVIEWED
    converted_in_db.public = True
    converted_in_db.name = 'Elrond'
    converted_in_db.save()
    assert converted_in_db.recording.name == original_name
    assert converted_in_db.recording.file == original_file
    assert converted_in_db.recording_web.name == original_web_name


def test_save_arbitrary_change_uf_converted(converted_in_db):
    original_name = converted_in_db.recording.name
    original_file = converted_in_db.recording.file
    original_web_name = converted_in_db.recording_web.name
    original_web_file = converted_in_db.recording_web.file
    converted_in_db.status = Recording.REVIEWED
    converted_in_db.public = True
    converted_in_db.name = 'Elrond'
    converted_in_db.save(update_fields=('status', 'public', 'name'))
    assert converted_in_db.recording.name == original_name
    assert converted_in_db.recording.file == original_file
    assert converted_in_db.recording_web.name == original_web_name
    assert converted_in_db.recording_web.file == original_web_file


def test_save_file_change_no_uf_converted_to_converted(converted_in_db, amr_file):
    original_name = converted_in_db.recording.name
    original_file = converted_in_db.recording.file
    original_web_name = converted_in_db.recording_web.name
    original_web_file = converted_in_db.recording_web.file
    converted_in_db.recording = File(amr_file)
    converted_in_db.save()
    assert converted_in_db.recording.name == original_name
    assert converted_in_db.recording.file != original_file
    assert converted_in_db.recording_web.name == original_web_name
    assert converted_in_db.recording_web.file != original_web_file
    assert op.basename(converted_in_db.recording_original_name) == op.basename(amr_file.name)


def test_save_file_change_uf_converted_to_converted(converted_in_db, amr_file):
    original_name = converted_in_db.recording.name
    original_file = converted_in_db.recording.file
    original_web_name = converted_in_db.recording_web.name
    original_web_file = converted_in_db.recording_web.file
    converted_in_db.recording = File(amr_file)
    converted_in_db.save(update_fields=('recording',))
    assert converted_in_db.recording.name == original_name
    assert converted_in_db.recording.file != original_file
    assert converted_in_db.recording_web.name == original_web_name
    assert converted_in_db.recording_web.file != original_web_file
    assert op.basename(converted_in_db.recording_original_name) == op.basename(amr_file.name)


def test_save_file_change_no_uf_converted_to_web_safe(converted_in_db, mp3_file):
    original_name = converted_in_db.recording.name
    original_file = converted_in_db.recording.file
    converted_in_db.recording = File(mp3_file)
    converted_in_db.save()
    assert converted_in_db.recording.name != original_name
    assert op.splitext(converted_in_db.recording.name)[0] == op.splitext(original_name)[0]
    assert converted_in_db.recording.file != original_file
    assert converted_in_db.recording_web == None
    assert op.basename(converted_in_db.recording_original_name) == op.basename(mp3_file.name)


def test_save_file_change_uf_converted_to_web_safe(converted_in_db, mp3_file):
    original_name = converted_in_db.recording.name
    original_file = converted_in_db.recording.file
    converted_in_db.recording = File(mp3_file)
    converted_in_db.save(update_fields=('recording',))
    assert converted_in_db.recording.name != original_name
    assert op.splitext(converted_in_db.recording.name)[0] == op.splitext(original_name)[0]
    assert converted_in_db.recording.file != original_file
    assert converted_in_db.recording_web == None
    assert op.basename(converted_in_db.recording_original_name) == op.basename(mp3_file.name)
