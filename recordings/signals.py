from mimetypes import guess_type
import os.path as op

from django.db.models.signals import post_save, post_delete
from django.conf import settings

from .convert_audio import convert_to_mp3

WEB_SAFE = ('audio/mpeg', 'audio/aac', 'audio/mp4')


def convert_web_recording(sender, **kwargs):
    """ Set instance.recording_web if instance.recording is not MP3 or AAC. """
    update_fields = kwargs.get('update_fields', None)
    if (
        update_fields and
        len(update_fields) == 1 and
        'recording_web' in update_fields
    ):
        return  # this prevents infinite recursion
    instance = kwargs.get('instance')
    instance.recording_web.delete(save=False)
    recording = instance.recording
    mime_type = guess_type(recording.name)
    if mime_type not in WEB_SAFE:
        full_path = op.join(settings.MEDIA_ROOT, recording.name)
        converted_mp3 = convert_to_mp3(full_path)
        relative_path = op.relpath(converted_mp3, settings.MEDIA_ROOT)
        instance.recording_web.name = relative_path
        instance.save(update_fields=('recording_web',))


def remove_recording_files(sender, **kwargs):
    """ Remove the audio files associated with the instance. """
    instance = kwargs.get('instance')
    instance.recording_web.delete(save=False)
    instance.recording.delete(save=False)


def connect_signals(app_instance):
    # See the .apps module for app_instance. We can't import the .models
    # directly at this time, hence the app_instance.get_model construction.
    Recording = app_instance.get_model('Recording')
    post_save.connect(
        convert_web_recording,
        sender=Recording,
        dispatch_uid='recordings.models.Recording#convert_web_recording',
    )
    post_delete.connect(
        remove_recording_files,
        sender=Recording,
        dispatch_uid='recordings.models.Recording#convert_web_recording',
    )
