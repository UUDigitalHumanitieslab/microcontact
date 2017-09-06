import os.path as op

from django.db import models

from .validators import FileSizeValidator, MediaTypeValidator

ACCEPTABLE_SIZE = 100 * 2**20  # 100MiB
ACCEPTABLE_TYPES = ['audio/*', 'application/octet-stream']


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


class AgeCategory(models.Model):
    least = models.IntegerField()
    greatest = models.IntegerField()


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
    generation_choices = (
        ('a', 'first'),
        ('b', 'second')
    )

    # administrative fields
    status = models.CharField(max_length=1, choices=status_choices, default='c')
    public = models.BooleanField(default=False)

    # details about the uploader
    name = models.CharField(max_length=200, blank=True)

    # details about the speaker
    sex = models.CharField(max_length=1, choices=sex_choices, blank=True)
    age = models.ForeignKey(AgeCategory, blank=True, null=True)
    place = models.ForeignKey(Place, on_delete="PROTECT")
    languages = models.ForeignKey(
        Language,
        on_delete="PROTECT",
        blank=True,
        null=True,
    )
    dialect = models.ForeignKey(Dialect, on_delete="PROTECT")
    generation = models.CharField(
        max_length=1,
        choices=generation_choices,
        null=True,
        blank=True,
    )
    migrated = models.DateField(null=True, blank=True)

    # the recording proper
    recording = models.FileField(
        upload_to='recordings',
        max_length=200,
        validators=[
            FileSizeValidator(max_size=ACCEPTABLE_SIZE),
            MediaTypeValidator(ACCEPTABLE_TYPES),
        ],
    )
    recording_web = models.FileField(
        upload_to='recordings',
        max_length=200,
        blank=True,
    )
    
    def get_web_recording(self):
        return self.recording_web or self.recording
    
    def __str__(self):
        return '{} ({})'.format(self.id, op.split(self.recording.name)[1])
