# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Dialect',
            fields=[
                ('id', models.AutoField(verbose_name='ID', primary_key=True, serialize=False, auto_created=True)),
                ('dialect', models.CharField(max_length=200)),
            ],
        ),
        migrations.CreateModel(
            name='Recording',
            fields=[
                ('id', models.AutoField(verbose_name='ID', primary_key=True, serialize=False, auto_created=True)),
                ('status', models.CharField(max_length=1, choices=[('a', 'censored'), ('b', 'reviewed'), ('c', 'open')])),
                ('name', models.CharField(max_length=200)),
                ('city', models.TextField()),
                ('province', models.TextField()),
                ('code', models.TextField()),
                ('sex', models.CharField(max_length=1, choices=[('a', 'male'), ('b', 'female'), ('c', '-')])),
                ('age', models.IntegerField()),
                ('city_coordinates_lon', models.FloatField()),
                ('city_coordinates_lng', models.FloatField()),
                ('recording', models.CharField(max_length=200)),
                ('dialect', models.ForeignKey(on_delete='PROTECT', to='recordings.Dialect')),
            ],
        ),
    ]
