from django.shortcuts import render
from rest_framework import generics
from .serializers import DialectSerializer
from .models import Dialect
# Create your views here.

class CreateView(generics.ListCreateAPIView):
    queryset = Dialect.objects.all()
    serializer_class = DialectSerializer

    def perform_create(self, serializer):
        serializer.save()

class DetailsView(generics.RetrieveUpdateDestroyAPIView):
    """This class handles the http GET, PUT and DELETE requests."""

    queryset = Dialect.objects.all()
    serializer_class = DialectSerializer
