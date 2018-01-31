# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0018_auto_20171221_1604'),
    ]

    operations = [
        migrations.AddField(
            model_name='recording',
            name='recording_original_name',
            field=models.CharField(blank=True, max_length=200),
        ),
    ]
