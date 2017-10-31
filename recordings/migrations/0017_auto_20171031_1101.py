# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import recordings.validators


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0016_auto_20171018_0840'),
    ]

    operations = [
        migrations.AlterField(
            model_name='recording',
            name='recording',
            field=models.FileField(validators=[
                recordings.validators.FileSizeValidator(max_size=104857600),
                recordings.validators.MediaTypeValidator([
                    'audio/*',
                    'video/mp4',
                    'application/octet-stream',
                ]),
            ], max_length=200, upload_to='recordings'),
        ),
    ]
