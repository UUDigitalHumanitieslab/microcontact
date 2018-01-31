from mimetypes import guess_type
import os
import os.path as op

from django.db.models.signals import post_save, post_delete
from django.conf import settings

from .convert_audio import convert_to_mp3
from .utils import get_absolute_path

WEB_SAFE = ('audio/mpeg', 'audio/mp4a-latm', 'video/mp4', 'audio/mp4')
FILENAME_FORMAT = 'microcontact_{id:07}{extension}'


def store_recording_files(sender, **kwargs):
    """
    Name recording after instance ID and convert to MP3 if necessary.
    
    This is a signal handler for django.db.models.signals.post_save.
    """
    resave = False
    update_fields = kwargs.get('update_fields', None)
    instance = kwargs.get('instance')
    old_path = get_absolute_path(instance.recording)
    directory, old_name = op.split(old_path)
    new_name, mime_type = standardize_filename(instance, old_name)
    new_path = op.join(directory, new_name)
    # import pdb; pdb.set_trace()
    if old_name != new_name:
        if new_name == op.basename(instance.recording_web.name):
            # this prevents problems in some corner cases
            instance.recording_web.delete(save=False)
        os.rename(old_path, new_path)
        instance.recording_original_name = old_name
        instance.recording.name = op.relpath(new_path, settings.MEDIA_ROOT)
        resave = True
    elif (
        update_fields and
        len(update_fields) >= 1 and (
            'recording_web' in update_fields or
            'recording' not in update_fields
        )
    ):
        return  # this prevents infinite recursion and saves work
    assert instance.recording != instance.recording_web
    if mime_type not in WEB_SAFE:
        instance.recording_web.delete(save=False)
        converted_mp3 = convert_to_mp3(new_path)
        relative_path = op.relpath(converted_mp3, settings.MEDIA_ROOT)
        instance.recording_web.name = relative_path
        resave = True
    if resave:
        instance.save(update_fields=(
            'recording_web',  # recursion prevention
            'recording',
            'recording_original_name',
        ))


def standardize_filename(recording, current_name):
    """
        Generate a standardized filename based on the recording attributes.
        
        `recording`: instance of .models.Recording.
    """
    mime_type, encoding = guess_type(current_name)
    std_extension = op.splitext(current_name)[1].lower()
    directory = op.dirname(current_name)
    std_name = FILENAME_FORMAT.format(id=recording.id, extension=std_extension)
    return op.join(directory, std_name), mime_type


def remove_recording_files(sender, **kwargs):
    """
    Remove the audio files associated with the instance.
    
    This is a signal handler for django.db.models.signals.post_delete.
    """
    instance = kwargs.get('instance')
    instance.recording_web.delete(save=False)
    instance.recording.delete(save=False)


def connect_signals(app_instance):
    # See the .apps module for app_instance. We can't import the .models
    # directly at this time, hence the app_instance.get_model construction.
    Recording = app_instance.get_model('Recording')
    post_save.connect(
        store_recording_files,
        sender=Recording,
        dispatch_uid='recordings.models.Recording#store_recording_files',
    )
    post_delete.connect(
        remove_recording_files,
        sender=Recording,
        dispatch_uid='recordings.models.Recording#remove_recording_files',
    )
