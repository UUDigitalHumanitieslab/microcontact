from django.shortcuts import render
from rest_framework import viewsets
from .serializers import *
from .models import Dialect, Language, Country, AgeCategory, Recording
# Create your views here.


class DialectViewSet(viewsets.ModelViewSet):
    queryset = Dialect.objects.all()
    serializer_class = DialectSerializer


class LanguageViewSet(viewsets.ModelViewSet):
    queryset = Language.objects.all()
    serializer_class = LanguageSerializer


class CountryViewSet(viewsets.ModelViewSet):
    queryset = Country.objects.all()
    serializer_class = CountrySerializer


class AgeCategoryViewSet(viewsets.ModelViewSet):
    queryset = AgeCategory.objects.all()
    serializer_class = AgeCategorySerializer


class RecordingViewSet(viewsets.ModelViewSet):
    queryset = Recording.objects.filter(public=True)
    serializer_class = RecordingSerializer
