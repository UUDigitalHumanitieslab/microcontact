# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0009_auto_20170906_1220'),
    ]

    operations = [
        migrations.RenameField(
            model_name='recording',
            old_name='speaker_generation',
            new_name='generation',
        ),
        migrations.RenameField(
            model_name='recording',
            old_name='year_migrated_to_americas',
            new_name='migrated',
        ),
        migrations.RenameField(
            model_name='recording',
            old_name='is_public_recording',
            new_name='public',
        ),
    ]
