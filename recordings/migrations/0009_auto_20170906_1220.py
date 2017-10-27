# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0008_auto_20170831_1454'),
    ]

    operations = [
        migrations.AlterField(
            model_name='recording',
            name='id',
            field=models.AutoField(primary_key=True, verbose_name='ID', serialize=False, auto_created=True),
        ),
    ]
