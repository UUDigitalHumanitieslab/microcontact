from django.shortcuts import render
from rest_framework import viewsets
from .serializers import *
from .models import Dialect, Country, Contribution
# Create your views here.


class DialectViewSet(viewsets.ModelViewSet):
    queryset = Dialect.objects.all()
    serializer_class = DialectSerializer


class CountryViewSet(viewsets.ModelViewSet):
    queryset = Country.objects.all()
    serializer_class = CountrySerializer


class ContributionViewSet(viewsets.ModelViewSet):
    queryset = Contribution.objects.all()
    serializer_class = ContributionSerializer
