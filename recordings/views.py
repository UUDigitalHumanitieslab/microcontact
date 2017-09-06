from django.shortcuts import render
from rest_framework import viewsets
from .serializers import *
from .models import Dialect, Country, Recording
# Create your views here.


class DialectViewSet(viewsets.ModelViewSet):
    queryset = Dialect.objects.all()
    serializer_class = DialectSerializer


class CountryViewSet(viewsets.ModelViewSet):
    queryset = Country.objects.all()
    serializer_class = CountrySerializer


class RecordingViewSet(viewsets.ModelViewSet):
    queryset = Recording.objects.filter(is_public_recording=True)
    serializer_class = RecordingSerializer
