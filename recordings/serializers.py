from rest_framework import serializers
from .models import Dialect, Language, Country, Place, AgeCategory, Recording


class DialectSerializer(serializers.ModelSerializer):
    """Serializer to map the Model instance into JSON format."""

    class Meta:
        """Meta class to map serializer's fields with the model fields."""
        model = Dialect
        fields = ('id', 'dialect', 'color')


class LanguageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Language
        fields = ('id', 'language')


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


class AgeCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = AgeCategory
        fields = ('id', 'least', 'greatest')


class RecordingSerializer(serializers.HyperlinkedModelSerializer):
    dialect = serializers.PrimaryKeyRelatedField(
        queryset=Dialect.objects.all(),
    )
    place = PlaceSerializer()
    languages = serializers.PrimaryKeyRelatedField(
        queryset=Language.objects.all(),
        many=True,
        write_only=True,
    )
    age = serializers.PrimaryKeyRelatedField(
        queryset=AgeCategory.objects.all(),
        write_only=True,
    )

    class Meta():
        model = Recording
        fields = (
            'url',
            'recording',
            'name',
            'email',
            'phone',
            'dialect',
            'place',
            'languages',
            'age',
            'sex',
            'education',
            'generation',
            'origin',
            'migrated',
        )
        extra_kwargs = {
            'name': {'write_only': True},
            'email': {
                'write_only': True,
                'required': False,
            },
            'phone': {
                'write_only': True,
                'required': False,
            },
            'sex': {'write_only': True},
            'education': {'write_only': True},
            'generation': {'write_only': True},
            'origin': {'write_only': True},
            'migrated': {
                'write_only': True,
                'required': False,
                'allow_null': True,
            },
        }
    
    def validate(self, data):
        email = data.get('email', None)
        phone = data.get('phone', None)
        if not email and not phone:
            raise serializers.ValidationError(
                'At least one of email, phone must be provided.'
            )
        return data
    
    def create(self, validated_data):
        place_data = validated_data.pop('place')
        placeID = place_data.pop('placeID')
        place, created = Place.objects.get_or_create(
            placeID=placeID,
            defaults=place_data,
        )
        validated_data['place'] = place
        return super().create(validated_data)
