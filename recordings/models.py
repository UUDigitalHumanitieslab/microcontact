import os.path as op

from django.db import models

# Create your models here.


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
    code = models.CharField(max_length=3, unique=True)

    class Meta:
        verbose_name_plural = 'Countries'


class Place(models.Model):
    placeID = models.CharField(max_length=200)
    name = models.CharField(max_length=200)
    latitude = models.FloatField()
    longitude = models.FloatField()
    country = models.ForeignKey(Country, on_delete="PROTECT")
    
    def __str__(self):
        return '{}, {}'.format(self.name, self.country.code)


class Recording(models.Model):
    status_choices = (
        ('a', 'censored'),
        ('b', 'reviewed'),
        ('c', 'open')
    )
    sex_choices = (
        ('a', 'male'),
        ('b', 'female'),
        ('c', '-')
    )
    speaker_generation_choices = (
        ('a', 'first'),
        ('b', 'second')
    )

    id = models.AutoField(primary_key=True)
    status = models.CharField(max_length=1, choices=status_choices, default='c')
    name = models.CharField(max_length=200, blank=True)
    sex = models.CharField(max_length=1, choices=sex_choices, blank=True)
    age = models.IntegerField(blank=True, null=True)
    languages = models.ForeignKey(Language, on_delete="PROTECT", blank=True, null=True)
    dialect = models.ForeignKey(Dialect, on_delete="PROTECT")
    is_public_recording = models.BooleanField(default=False)
    speaker_generation = models.CharField(max_length=1, choices=speaker_generation_choices, null=True, blank=True)
    place = models.ForeignKey(Place, on_delete="PROTECT")
    year_migrated_to_americas = models.DateField(null=True, blank=True)
    recording = models.FileField(upload_to='recordings', max_length=200)
    
    def __str__(self):
        return '{} ({})'.format(self.id, op.split(self.recording.name)[1])
