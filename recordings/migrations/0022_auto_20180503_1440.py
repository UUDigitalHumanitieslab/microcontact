# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from importlib import import_module

from django.db import migrations, models

ancestor0015 = import_module('recordings.migrations.0015_auto_20170914_1004')
ancestor0016 = import_module('recordings.migrations.0016_auto_20171018_0840')
ancestor0019 = import_module('recordings.migrations.0019_auto_20180116_1105')

# Same order as in ancestor0015
DIALECT_DEFAULTS_ENGLISH = (
    'Abruzzese/Teatino',
    'Florentine',
    'Neapolitan',
    'Palermitan',
    'Piedmontese',
    'Salentino',
    'Sienese',
    'Venetan',
    'other',
)

# Same order as in ancestor0016
COUNTRY_DEFAULTS_ENGLISH = (
    'Argentina',
    'Brazil',
    'Canada',
    'Italy',
    'USA',
)

# Same order as in ancestor0019.LANGUAGE_RESTRICTED_SET
LANGUAGE_DEFAULTS_ENGLISH = (
    'Italian',
    'French',
    'Spanish',
    'Portuguese',
    'English',
    'other',
)


def insert_English_dialects(apps, schema_editor):
    """ Insert the English translations into the new Dialect.en column. """
    Dialect = apps.get_model('recordings', 'Dialect')
    objects = Dialect.objects
    for (it, color), en in zip(ancestor0015.DIALECT_DEFAULTS_ITALIAN, DIALECT_DEFAULTS_ENGLISH):
        dialect = objects.filter(it=it).first() or objects.filter(color=color).first()
        if dialect:
            dialect.en = en
            dialect.save()


def insert_English_countries(apps, schema_editor):
    """ Insert the English translations into the new Country.en column. """
    Country = apps.get_model('recordings', 'Country')
    objects = Country.objects
    for (code, it), en in zip(ancestor0016.COUNTRY_DEFAULTS_ITALIAN, COUNTRY_DEFAULTS_ENGLISH):
        country = objects.filter(code=code).first()
        if country:
            country.en = en
            country.save()


def insert_English_languages(apps, schema_editor):
    """ Insert the English translations into the new Country.en column. """
    Language = apps.get_model('recordings', 'Language')
    objects = Language.objects
    for it, en in zip(ancestor0019.LANGUAGE_RESTRICTED_SET, LANGUAGE_DEFAULTS_ENGLISH):
        language = objects.filter(it=it).first()
        if language:
            language.en = en
            language.save()


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0021_merge'),
    ]

    operations = [
        migrations.RenameField(
            model_name='country',
            old_name='name',
            new_name='it',
        ),
        migrations.RenameField(
            model_name='dialect',
            old_name='dialect',
            new_name='it',
        ),
        migrations.RenameField(
            model_name='language',
            old_name='language',
            new_name='it',
        ),
        migrations.AlterField(
            model_name='country',
            name='it',
            field=models.CharField(default='', max_length=200),
        ),
        migrations.AlterField(
            model_name='dialect',
            name='it',
            field=models.CharField(default='', max_length=200),
        ),
        migrations.AlterField(
            model_name='language',
            name='it',
            field=models.CharField(default='', max_length=200),
        ),
        migrations.AddField(
            model_name='country',
            name='en',
            field=models.CharField(default='', max_length=200),
        ),
        migrations.AddField(
            model_name='country',
            name='es',
            field=models.CharField(default='', max_length=200),
        ),
        migrations.AddField(
            model_name='country',
            name='fr',
            field=models.CharField(default='', max_length=200),
        ),
        migrations.AddField(
            model_name='country',
            name='pt',
            field=models.CharField(default='', max_length=200),
        ),
        migrations.AddField(
            model_name='dialect',
            name='en',
            field=models.CharField(default='', max_length=200),
        ),
        migrations.AddField(
            model_name='dialect',
            name='es',
            field=models.CharField(default='', max_length=200),
        ),
        migrations.AddField(
            model_name='dialect',
            name='fr',
            field=models.CharField(default='', max_length=200),
        ),
        migrations.AddField(
            model_name='dialect',
            name='pt',
            field=models.CharField(default='', max_length=200),
        ),
        migrations.AddField(
            model_name='language',
            name='en',
            field=models.CharField(default='', max_length=200),
        ),
        migrations.AddField(
            model_name='language',
            name='es',
            field=models.CharField(default='', max_length=200),
        ),
        migrations.AddField(
            model_name='language',
            name='fr',
            field=models.CharField(default='', max_length=200),
        ),
        migrations.AddField(
            model_name='language',
            name='pt',
            field=models.CharField(default='', max_length=200),
        ),
        migrations.RunPython(
            insert_English_dialects,
            migrations.RunPython.noop,
        ),
        migrations.RunPython(
            insert_English_countries,
            migrations.RunPython.noop,
        ),
        migrations.RunPython(
            insert_English_languages,
            migrations.RunPython.noop,
        ),
    ]
