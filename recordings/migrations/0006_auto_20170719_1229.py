# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0005_country_code'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='recording',
            name='city',
        ),
        migrations.RemoveField(
            model_name='recording',
            name='code',
        ),
        migrations.RemoveField(
            model_name='recording',
            name='province',
        ),
        migrations.RemoveField(
            model_name='recording',
            name='street',
        ),
        migrations.RemoveField(
            model_name='recording',
            name='street_number',
        ),
        migrations.AlterField(
            model_name='recording',
            name='age',
            field=models.IntegerField(null=True, blank=True),
        ),
        migrations.AlterField(
            model_name='recording',
            name='languages',
            field=models.ForeignKey(blank=True, on_delete=models.PROTECT, to='recordings.Language', null=True),
        ),
        migrations.AlterField(
            model_name='recording',
            name='name',
            field=models.CharField(blank=True, max_length=200),
        ),
        migrations.AlterField(
            model_name='recording',
            name='sex',
            field=models.CharField(blank=True, choices=[('a', 'male'), ('b', 'female'), ('c', '-')], max_length=1),
        ),
        migrations.AlterField(
            model_name='recording',
            name='speaker_generation',
            field=models.CharField(null=True, blank=True, choices=[('a', 'first'), ('b', 'second')], max_length=1),
        ),
        migrations.AlterField(
            model_name='recording',
            name='status',
            field=models.CharField(max_length=1, choices=[('a', 'censored'), ('b', 'reviewed'), ('c', 'open')], default='c'),
        ),
    ]
