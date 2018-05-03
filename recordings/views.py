from django.shortcuts import render
from rest_framework import viewsets, mixins
from .serializers import *
from .models import Dialect, Language, Country, Place, AgeCategory, Recording


class CreateReadModelViewSet(
        mixins.CreateModelMixin,
        mixins.ListModelMixin,
        mixins.RetrieveModelMixin,
        viewsets.GenericViewSet,
    ):
    """
    A viewset that provides `retrieve`, `create`, and `list` actions.

    Importantly, this class does not provide `update`, `partial_update`
    or `destroy`.
    To use it, override the class and set the `.queryset` and
    `.serializer_class` attributes.
    
    This class was copied from the example over here:
    http://www.django-rest-framework.org/api-guide/viewsets/#custom-viewset-base-classes
    """
    pass


class DialectViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Dialect.objects.all()
    serializer_class = DialectSerializer


class LanguageViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Language.objects.all()
    serializer_class = LanguageSerializer


class CountryViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Country.objects.all()
    serializer_class = CountrySerializer


class PlaceViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Place.objects.all()
    serializer_class = PlaceRecordingsSerializer


class AgeCategoryViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = AgeCategory.objects.all()
    serializer_class = AgeCategorySerializer


class RecordingViewSet(CreateReadModelViewSet):
    queryset = Recording.objects.filter(public=True)
    serializer_class = RecordingSerializer
