# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


""" WARNING: this migration destroys data (in theory).

    The field Recording.recording_link is removed, without any attempt
    to save the data therein. This is a theoretical problem, as the
    web application has not actually supported file uploads to this
    field up to this point in migration history.
"""


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0003_auto_20170713_1440'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='recording',
            name='recording_link',
        ),
        migrations.AddField(
            model_name='recording',
            name='recording',
            field=models.FileField(max_length=200, upload_to='recordings', default='replace'),
            preserve_default=False,
        ),
    ]
