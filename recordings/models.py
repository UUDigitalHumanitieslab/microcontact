from django.db import models

# Create your models here.

from django.db import models


class Dialect(models.Model):
    dialect = models.CharField(max_length=200)


class Language(models.Model):
    language = models.CharField(max_length=200)

class Recording(models.Model):
    id = models.AutoField(primary_key=True)
    status_choices = (
        ('a', 'censored'),
        ('b', 'reviewed'),
        ('c', 'open')
    )
    status = models.CharField(max_length=1, choices=status_choices)
    name = models.CharField(max_length=200)
    street = models.TextField(max_length=200)
    street_number = models.CharField(max_length=8)
    city = models.TextField()
    province = models.TextField()
    code = models.TextField()
    sex_choices = (
        ('a', 'male'),
        ('b', 'female'),
        ('c', '-')
    )
    sex = models.CharField(max_length=1, choices=sex_choices)
    age = models.IntegerField()
    languages = models.ForeignKey(Language, on_delete="PROTECT")
    dialect = models.ForeignKey(Dialect, on_delete="PROTECT")
    is_public_recording = models.BooleanField(default=False)
    speaker_generation_choices = (
        ('a', 'first')
        ('b', 'second')
    )
    speaker_generation = models.CharField(max_length=1, choices=speaker_generation_choices)
    city_coordinates_lon = models.FloatField()
    city_coordinates_lng = models.FloatField()
    year_migrated_to_americas = models.DateField(null=True, blank=True)
    recording_link = models.CharField(max_length=200)
