# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0025_auto_20180605_1236'),
    ]

    operations = [
        migrations.AddField(
            model_name='recording',
            name='relation_to_speaker',
            field=models.CharField(blank=True, verbose_name="uploader's relation to speaker", max_length=75, default='Not specified (was uploaded before this information was collected)'),
        ),
    ]
