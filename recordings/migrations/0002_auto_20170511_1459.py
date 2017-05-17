# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0001_initial'),
    ]

    operations = [
        migrations.RenameField(
            model_name='recording',
            old_name='recording',
            new_name='recording_link',
        ),
        migrations.AddField(
            model_name='recording',
            name='street',
            field=models.TextField(max_length=200, default=''),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='recording',
            name='street_number',
            field=models.CharField(max_length=8, default=''),
            preserve_default=False,
        ),
    ]
