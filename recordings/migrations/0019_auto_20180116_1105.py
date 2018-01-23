# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from importlib import import_module

from django.db import migrations, models

ancestor0016 = import_module('recordings.migrations.0016_auto_20171018_0840')

OTHER = 'altro'
LANGUAGE_RESTRICTED_SET = ancestor0016.LANGUAGE_DEFAULTS_ITALIAN + (OTHER,)


def normalize_languages(apps, schema_editor):
    """ Reduce all languages not in LANGUAGE_RESTRICTED_SET to OTHER. """
    Language = apps.get_model('recordings', 'Language')
    other, created = Language.objects.get_or_create(language=OTHER)
    if created:
        other.save()
    obsolete = Language.objects.exclude(language__in=LANGUAGE_RESTRICTED_SET)
    for language in obsolete.all():
        for recording in language.recording_set.all():
            if other not in recording.languages.all():
                recording.languages.add(other)
        language.recording_set.clear()
    obsolete.delete()


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0018_auto_20171221_1604'),
    ]

    operations = [
        migrations.RunPython(normalize_languages, migrations.RunPython.noop),
    ]
