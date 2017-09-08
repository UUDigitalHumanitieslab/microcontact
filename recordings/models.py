import os.path as op

from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator

from phonenumber_field.modelfields import PhoneNumberField

from .validators import FileSizeValidator, MediaTypeValidator

ACCEPTABLE_SIZE = 100 * 2**20  # 100MiB
ACCEPTABLE_TYPES = ['audio/*', 'application/octet-stream']
TURN_OF_19TH_CENTURY = 1890
END_OF_RESEARCH_PROJECT = 2021


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
    
    def __str__(self):
        return '{}-{}'.format(self.least, self.greatest)


class Recording(models.Model):
    CENSORED       = 'a'
    REVIEWED       = 'b'
    OPEN           = 'c'
    MALE           = 'a'
    FEMALE         = 'b'
    OTHER          = 'c'
    FIRST_GEN      = 'a'
    SECOND_GEN     = 'b'
    ELEMENTARY_EDU = 'e'
    MIDDLE_EDU     = 'm'
    HIGH_EDU       = 'h'
    UNIVERSITY_EDU = 'u'
    status_choices = (
        (CENSORED, 'censored'),
        (REVIEWED, 'reviewed'),
        (OPEN, 'open')
    )
    sex_choices = (
        (MALE, 'male'),
        (FEMALE, 'female'),
        (OTHER, '-')
    )
    generation_choices = (
        (FIRST_GEN, 'first'),
        (SECOND_GEN, 'second')
    )
    education_choices = (
        (ELEMENTARY_EDU, 'elementary'),
        (MIDDLE_EDU, 'middle'),
        (HIGH_EDU, 'high'),
        (UNIVERSITY_EDU, 'university'),
    )

    # administrative fields
    status = models.CharField(
        max_length=1,
        choices=status_choices,
        default=OPEN,
    )
    public = models.BooleanField(default=False)

    # details about the uploader
    name = models.CharField(max_length=200, blank=True)
    email = models.EmailField('uploader\'s email address', blank=True)
    phone = PhoneNumberField('uploader\'s phone number', blank=True)

    # details about the speaker
    sex = models.CharField(max_length=1, choices=sex_choices, blank=True)
    age = models.ForeignKey(AgeCategory, blank=True, null=True)
    place = models.ForeignKey(Place, on_delete="PROTECT")
    languages = models.ManyToManyField(Language, blank=True)
    dialect = models.ForeignKey(Dialect, on_delete="PROTECT")
    generation = models.CharField(
        max_length=1,
        choices=generation_choices,
        null=True,
        blank=True,
    )
    migrated = models.IntegerField(null=True, blank=True, validators=[
        MinValueValidator(TURN_OF_19TH_CENTURY),
        MaxValueValidator(END_OF_RESEARCH_PROJECT),
    ])
    origin = models.CharField(
        'speaker\'s village of origin',
        blank=True,
        max_length=200,
    )
    education = models.CharField(
        'speaker\'s level of education',
        blank=True,
        max_length=1,
        choices=education_choices,
    )

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
