# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import django.core.validators

DIALECT_DEFAULTS_ITALIAN = (
    ('Abruzzese/Teatino', '#901'),
    ('Fiorentino', '#fff'),
    ('Napoletano (Campano)', '#d12'),
    ('Palermitano (Siciliano)', '#160'),
    ('Piemontese', '#04e'),
    ('Salentino', '#394'),
    ('Senese (Toscano)', '#bbb'),
    ('Veneto', '#223'),
    ('altro', '#855'),
)


def rename_other_to_altro(apps, schema_editor):
    """ Ensure that the 'other' category is represented in Italian. """
    Dialect = apps.get_model('recordings', 'Dialect')
    other = Dialect.objects.filter(dialect='other').first()
    if other:
        other.dialect = 'altro'
        other.save()


def ensure_default_dialects_with_colors(apps, schema_editor):
    """ Represent the formerly hardcoded list from the client side in DB. """
    Dialect = apps.get_model('recordings', 'Dialect')
    for name, color in DIALECT_DEFAULTS_ITALIAN:
        dialect, created = Dialect.objects.update_or_create(
            dialect=name,
            defaults={'color': color},
        )
        dialect.save()


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0014_auto_20170907_1405'),
    ]

    operations = [
        migrations.AddField(
            model_name='dialect',
            name='color',
            field=models.CharField(
                validators=[django.core.validators.RegexValidator(
                    '^#([0-9a-fA-F]{3})+$',
                    'Enter an RGB color code.',
                )],
                max_length=7,
                default='#000',
            ),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='dialect',
            name='dialect',
            field=models.CharField(max_length=200, unique=True),
        ),
        migrations.RunPython(
            rename_other_to_altro,
            reverse_code=migrations.RunPython.noop,
        ),
        migrations.RunPython(
            ensure_default_dialects_with_colors,
            reverse_code=migrations.RunPython.noop,
        ),
    ]
