# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


def remove_age_data(apps, schema_editor):
    """
    Remove pre-existing age data from the Recording model.

    No such data should exist, as the application has not used the
    field until now. This is purely for the convenience of developers
    who may have manually inserted ages in recording objects for test
    purposes.
    """
    Recording = apps.get_model('recordings', 'Recording')
    Recording.objects.filter(age__isnull=False).update(age=None)


def insert_default_age_categories(apps, schema_editor):
    """ Insert the age categories agreed with the project researcher. """
    AgeCategory = apps.get_model('recordings', 'AgeCategory')
    AgeCategory.objects.bulk_create([AgeCategory(least=18, greatest=25)] + [
        AgeCategory(least=i, greatest=i+4) for i in range(26, 100, 5)
    ] + [AgeCategory(least=101, greatest=200)])


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0010_auto_20170906_1240'),
    ]

    operations = [
        migrations.CreateModel(
            name='AgeCategory',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('least', models.IntegerField()),
                ('greatest', models.IntegerField()),
            ],
        ),
        migrations.RunPython(
            insert_default_age_categories,
            migrations.RunPython.noop,
        ),
        migrations.RunPython(remove_age_data, migrations.RunPython.noop),
        migrations.AlterField(
            model_name='recording',
            name='age',
            field=models.ForeignKey(null=True, blank=True, to='recordings.AgeCategory', on_delete=models.CASCADE),
        ),
    ]
