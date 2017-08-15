from rest_framework import serializers
from .models import Dialect, Country, Place, Contribution


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


class ContributionSerializer(serializers.HyperlinkedModelSerializer):
    dialect = serializers.PrimaryKeyRelatedField(
        queryset=Dialect.objects.all(),
    )
    place = PlaceSerializer()

    class Meta():
        model = Contribution
        fields = ('url', 'recording', 'dialect', 'place')
    
    def create(self, validated_data):
        place_data = validated_data.pop('place')
        placeID = place_data.pop('placeID')
        place, created = Place.objects.get_or_create(
            placeID=placeID,
            defaults=place_data,
        )
        validated_data['place'] = place
        return super().create(validated_data)
