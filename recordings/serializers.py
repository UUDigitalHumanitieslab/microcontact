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
        fields = ('id', 'name')


class PlaceSerializer(serializers.ModelSerializer):
    country = serializers.StringRelatedField()

    class Meta:
        model = Place
        fields = ('id', 'placeID', 'name', 'latitude', 'longitude', 'country')

    def to_internal_value(self, data):
        """ Permit parsing of objects from the Google Maps API. """
        return super().to_internal_value(data)


class RecordingSerializer(serializers.HyperlinkedModelSerializer):
    class Meta():
        model = Recording
        fields = ('url', 'recording', 'dialect', 'place')
