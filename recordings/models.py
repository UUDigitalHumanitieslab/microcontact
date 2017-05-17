from django.db import models

# Create your models here.

from django.db import models


class Dialect(models.Model):
    dialect = models.CharField(max_length=200)


class Recording(models.Model):
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
    dialect = models.ForeignKey(Dialect, on_delete="PROTECT")
    city_coordinates_lon = models.FloatField()
    city_coordinates_lng = models.FloatField()
    recording_link = models.CharField(max_length=200)
