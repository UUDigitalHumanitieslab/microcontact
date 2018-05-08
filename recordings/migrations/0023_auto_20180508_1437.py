# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('recordings', '0022_auto_20180503_1440'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='recording',
            options={'permissions': (('view_uploader_contactdetails', 'Can see contactdetails of the uploader'),)},
        ),
    ]
