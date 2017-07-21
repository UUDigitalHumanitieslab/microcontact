from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
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
    queryset = Recording.objects.all()
    serializer_class = RecordingSerializer
    
    @csrf_exempt
    def create(self, request):
        return super().create(request)
