# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models

COUNTRY_DEFAULTS_ITALIAN = (
    ('AR', 'Argentina'),
    ('BR', 'Brasile'),
    ('CA', 'Canada'),
    ('IT', 'Italia'),
    ('US', 'USA'),
)

LANGUAGE_DEFAULTS_ITALIAN = (
    'italiano',
    'francese',
    'spagnolo',
    'portoghese',
    'inglese',
)


def ensure_default_countries(apps, schema_editor):
    Country = apps.get_model('recordings', 'Country')
    for code, name in COUNTRY_DEFAULTS_ITALIAN:
        country, created = Country.objects.update_or_create(
            code=code,
            defaults={'name': name},
        )
        country.save()


def ensure_default_languages(apps, schema_editor):
    Language = apps.get_model('recordings', 'Language')
    for name in LANGUAGE_DEFAULTS_ITALIAN:
        language, created = Language.objects.get_or_create(language=name)
        if created:
            language.save()


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0015_auto_20170914_1004'),
    ]

    operations = [
        migrations.RunPython(
            ensure_default_countries,
            reverse_code=migrations.RunPython.noop,
        ),
        migrations.RunPython(
            ensure_default_languages,
            reverse_code=migrations.RunPython.noop,
        ),
    ]
