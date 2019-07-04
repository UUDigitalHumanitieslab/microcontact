# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0017_auto_20171031_1101'),
    ]

    operations = [
        migrations.AlterField(
            model_name='recording',
            name='place',
            field=models.ForeignKey(on_delete=models.PROTECT, to='recordings.Place', related_name='recordings'),
        ),
    ]
