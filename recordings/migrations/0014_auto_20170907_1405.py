# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from datetime import date

from django.db import migrations, models
import django.core.validators


def date_to_year(apps, schema_editor):
    """ Extract the year from Recording.migrated and put it in .migrated2. """
    Recording = apps.get_model('recordings', 'Recording')
    for recording in Recording.objects.all():
        if recording.migrated is not None:
            recording.migrated2 = recording.migrated.year
            recording.save()


def year_to_date(apps, schema_editor):
    """ Extract Recording.migrated2 and make it the year of .migrated. """
    Recording = apps.get_model('recordings', 'Recording')
    for recording in Recording.objects.all():
        if recording.migrated2 is not None:
            recording.migrated = date(recording.migrated2, 1, 1)
            recording.save()


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0013_auto_20170907_1332'),
    ]

    operations = [
        migrations.AddField(
            model_name='recording',
            name='migrated2',
            field=models.IntegerField(blank=True, validators=[django.core.validators.MinValueValidator(1890), django.core.validators.MaxValueValidator(2021)], null=True),
        ),
        migrations.RunPython(date_to_year, year_to_date),
        migrations.RemoveField('recording', 'migrated'),
        migrations.RenameField(
            model_name='recording',
            old_name='migrated2',
            new_name='migrated',
        ),
    ]
