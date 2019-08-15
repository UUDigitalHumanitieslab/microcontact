# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Country',
            fields=[
                ('id', models.AutoField(primary_key=True, auto_created=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=200)),
            ],
        ),
        migrations.CreateModel(
            name='Dialect',
            fields=[
                ('id', models.AutoField(primary_key=True, auto_created=True, serialize=False, verbose_name='ID')),
                ('dialect', models.CharField(max_length=200)),
            ],
        ),
        migrations.CreateModel(
            name='Language',
            fields=[
                ('id', models.AutoField(primary_key=True, auto_created=True, serialize=False, verbose_name='ID')),
                ('language', models.CharField(max_length=200)),
            ],
        ),
        migrations.CreateModel(
            name='Place',
            fields=[
                ('id', models.AutoField(primary_key=True, auto_created=True, serialize=False, verbose_name='ID')),
                ('placeID', models.CharField(max_length=200)),
                ('name', models.CharField(max_length=200)),
                ('latitude', models.FloatField()),
                ('longitude', models.FloatField()),
                ('country', models.ForeignKey(to='recordings.Country', on_delete=models.PROTECT)),
            ],
        ),
        migrations.CreateModel(
            name='Recording',
            fields=[
                ('id', models.AutoField(serialize=False, primary_key=True)),
                ('status', models.CharField(max_length=1, choices=[('a', 'censored'), ('b', 'reviewed'), ('c', 'open')])),
                ('name', models.CharField(max_length=200)),
                ('street', models.TextField(max_length=200)),
                ('street_number', models.CharField(max_length=8)),
                ('city', models.TextField()),
                ('province', models.TextField()),
                ('code', models.TextField()),
                ('sex', models.CharField(max_length=1, choices=[('a', 'male'), ('b', 'female'), ('c', '-')])),
                ('age', models.IntegerField()),
                ('is_public_recording', models.BooleanField(default=False)),
                ('speaker_generation', models.CharField(null=True, max_length=1, choices=[('a', 'first'), ('b', 'second')])),
                ('year_migrated_to_americas', models.DateField(null=True, blank=True)),
                ('recording_link', models.CharField(max_length=200)),
                ('dialect', models.ForeignKey(to='recordings.Dialect', on_delete=models.PROTECT)),
                ('languages', models.ForeignKey(to='recordings.Language', on_delete=models.PROTECT)),
                ('place', models.ForeignKey(on_delete=models.PROTECT, null=True, to='recordings.Place')),
            ],
        ),
    ]
