# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0023_auto_20180508_1437'),
    ]

    operations = [
        migrations.AddField(
            model_name='recording',
            name='recording_original_corpus',
            field=models.CharField(max_length=200, blank=True),
        ),
    ]
