from django.db import models

# Create your models here.

from django.db import models


class ModelWithName:
    def __str__(self):
        return self.name


class Dialect(models.Model):
    dialect = models.CharField(max_length=200)
    def __str__(self):
        return self.dialect


class Language(models.Model):
    language = models.CharField(max_length=200)

    def __str__(self):
        return self.language


class Country(ModelWithName, models.Model):
    name = models.CharField(max_length=200)

    class Meta:
        verbose_name_plural = 'Countries'


class Place(ModelWithName, models.Model):
    placeID = models.CharField(max_length=200)
    name = models.CharField(max_length=200)
    latitude = models.FloatField()
    longitude = models.FloatField()
    country = models.ForeignKey(Country, on_delete="PROTECT")


class Recording(ModelWithName, models.Model):
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
        ('a', 'first'),
        ('b', 'second')
    )
    speaker_generation = models.CharField(max_length=1, choices=speaker_generation_choices, null=True)
    place = models.ForeignKey(Place, on_delete="PROTECT")
    year_migrated_to_americas = models.DateField(null=True, blank=True)
    recording_link = models.CharField(max_length=200)
