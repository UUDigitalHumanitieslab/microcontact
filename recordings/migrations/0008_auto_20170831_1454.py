# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import recordings.validators


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0007_recording_recording_web'),
    ]

    operations = [
        migrations.AlterField(
            model_name='recording',
            name='recording',
            field=models.FileField(max_length=200, validators=[recordings.validators.FileSizeValidator(max_size=104857600), recordings.validators.MediaTypeValidator(['audio/*', 'application/octet-stream'])], upload_to='recordings'),
        ),
    ]
