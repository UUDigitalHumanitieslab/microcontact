# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='recording',
            name='place',
            field=models.ForeignKey(to='recordings.Place', on_delete=models.PROTECT),
        ),
    ]
