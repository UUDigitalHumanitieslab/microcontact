# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.core.validators


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0013_auto_20170907_1332'),
    ]

    operations = [
        migrations.AlterField(
            model_name='recording',
            name='migrated',
            field=models.IntegerField(blank=True, validators=[django.core.validators.MinValueValidator(1890), django.core.validators.MaxValueValidator(2021)], null=True),
        ),
    ]
