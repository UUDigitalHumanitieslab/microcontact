# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


def increment(code):
    """ Treats alphabetical `code` as a number and increments it as such. """
    copy = reversed(code)
    for index, character in enumerate(copy):
        if character == 'Z':
            copy[index] = 'A'
        elif not character.isupper():
            copy[index] = 'A'
            break
        else:
            copy[index] = chr(ord(character) + 1)
            break
    return reversed(copy)


def insert_temporary_code(apps, schema_editor):
    """ Sets a unique placeholder for the actual country code. """
    Country = apps.get_model('recordings', 'Country')
    used_codes = set()
    for country in Country.objects.all():
        candidate_code = country.name[:3].upper()
        while candidate_code in used_codes:
            # This will be inefficient if you have many countries.
            # The application is intended for researchers who crowdsource
            # in a small number of countries, so this shouldn't be an issue.
            candidate_code = increment(candidate_code)
        country.code = candidate_code
        country.save()
        used_codes.add(candidate_code)


def noop(apps, schema_editor):
    """ Reverse operation for `insert_temporary_code`. """
    pass


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0004_auto_20170718_1335'),
    ]

    operations = [
        migrations.AddField(
            model_name='country',
            name='code',
            field=models.CharField(max_length=3, blank=True),
        ),
        migrations.RunPython(insert_temporary_code, noop),
        migrations.AlterField(
            model_name='country',
            name='code',
            field=models.CharField(max_length=3, blank=False, unique=True),
        ),
    ]
