# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import phonenumber_field.modelfields


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0011_auto_20170906_1300'),
    ]

    operations = [
        migrations.AddField(
            model_name='recording',
            name='education',
            field=models.CharField(blank=True, choices=[('e', 'elementary'), ('m', 'middle'), ('h', 'high'), ('u', 'university')], verbose_name="speaker's level of education", max_length=1),
        ),
        migrations.AddField(
            model_name='recording',
            name='email',
            field=models.EmailField(blank=True, max_length=254, verbose_name="uploader's email address"),
        ),
        migrations.AddField(
            model_name='recording',
            name='origin',
            field=models.CharField(blank=True, max_length=200, verbose_name="speaker's village of origin"),
        ),
        migrations.AddField(
            model_name='recording',
            name='phone',
            field=phonenumber_field.modelfields.PhoneNumberField(blank=True, max_length=128, verbose_name="uploader's phone number"),
        ),
    ]
