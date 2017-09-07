# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):
    """
    Change Recording.languages from many-to-one to many-to-many.
    
    Strictly speaking, this should have been a single AlterField
    operation. The combination of RemoveField and AddField that is
    used instead, would generally lead to unnecessary data loss. In
    this case, however, the chosen construction is justified in two
    ways:
    
     1. The `languages` field hasn't been used by the application so
        far, so it should contain no valuable data.
     2. Django almost certainly cannot automatically convert a
        ForeignKey field to a ManyToMany field, let alone do the
        opposite. So the present construction is the most frictionless.
    """

    dependencies = [
        ('recordings', '0012_auto_20170907_1321'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='recording',
            name='languages',
        ),
        migrations.AddField(
            model_name='recording',
            name='languages',
            field=models.ManyToManyField(to='recordings.Language', blank=True),
        ),
    ]
