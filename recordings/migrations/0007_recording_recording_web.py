# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0006_auto_20170719_1229'),
    ]

    operations = [
        migrations.AddField(
            model_name='recording',
            name='recording_web',
            field=models.FileField(max_length=200, blank=True, upload_to='recordings'),
        ),
    ]
