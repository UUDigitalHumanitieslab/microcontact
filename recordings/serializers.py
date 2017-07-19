from rest_framework import serializers
from .models import Dialect, Country, Place, Recording


class DialectSerializer(serializers.ModelSerializer):
    """Serializer to map the Model instance into JSON format."""

    class Meta:
        """Meta class to map serializer's fields with the model fields."""
        model = Dialect
        fields = ('id', 'dialect')


class CountrySerializer(serializers.ModelSerializer):
    class Meta:
        model = Country
        fields = ('id', 'name', 'code')


class PlaceSerializer(serializers.ModelSerializer):
    country = serializers.SlugRelatedField(
        slug_field='code',
        queryset=Country.objects.all(),
    )

    class Meta:
        model = Place
        fields = ('id', 'placeID', 'name', 'latitude', 'longitude', 'country')


class RecordingSerializer(serializers.HyperlinkedModelSerializer):
    class Meta():
        model = Recording
        fields = ('url', 'recording', 'dialect', 'place')
