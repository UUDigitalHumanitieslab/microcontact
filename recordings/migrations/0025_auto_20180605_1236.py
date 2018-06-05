# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0024_recording_recording_original_corpus'),
    ]

    operations = [
        migrations.RenameField(
            model_name='recording',
            old_name='recording_original_corpus',
            new_name='recording_original_datasource',
        ),
    ]
