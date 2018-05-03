# -*- coding: utf-8 -*-
from __future__ import unicode_literals
import os.path as op

from django.db import migrations, models

from recordings.signals import store_recording_files


def rename_existing_files(apps, schema_editor):
    """ Apply uniform file names to all recordings in the database. """
    Recording = apps.get_model('recordings', 'Recording')
    for recording in Recording.objects.all():
        # the following lines prevent data loss
        if recording.recording_web.name == recording.recording.name:
            recording.recording_web.name = ''
        # manually apply the post-save hook
        store_recording_files(Recording, instance=recording)
        # clean up needlessly converted web versions
        if (
            recording.recording_web != None and
            recording.recording_web.name != '' and
            # The next condition is only true if no conversion is needed, but
            # there exists one because e.g. an m4a file was previously
            # converted to mp3 because of logic errors in the former
            # recordings.signals.convert_web_recording.
            op.splitext(recording.recording_web.name)[0] != op.splitext(recording.recording.name)[0]
        ):
            recording.recording_web.name = ''
            recording.save(update_fields=('recording_web',))
            # we could delete instead, but we won't do it just in case


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0019_recording_recording_original_name'),
    ]

    operations = [
        migrations.RunPython(rename_existing_files, migrations.RunPython.noop),
    ]
