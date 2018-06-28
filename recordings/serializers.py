from rest_framework import serializers
from .models import Dialect, Language, Country, Place, AgeCategory, Recording


class DialectSerializer(serializers.ModelSerializer):
    dialect = serializers.SerializerMethodField()
    
    # alias of the Italian localization for backwards compatibility
    def get_dialect(self, dialect):
        return dialect.it

    class Meta:
        """Meta class to map serializer's fields with the model fields."""
        model = Dialect
        fields = ('id', 'en', 'es', 'fr', 'it', 'pt', 'color', 'dialect')


class LanguageSerializer(serializers.ModelSerializer):
    language = serializers.SerializerMethodField()
    
    # alias of the Italian localization for backwards compatibility
    def get_language(self, language):
        return language.it
    
    class Meta:
        model = Language
        fields = ('id', 'en', 'es', 'fr', 'it', 'pt', 'language')


class CountrySerializer(serializers.ModelSerializer):
    name = serializers.SerializerMethodField()
    
    # alias of the Italian localization for backwards compatibility
    def get_name(self, country):
        return country.it
    
    class Meta:
        model = Country
        fields = ('id', 'en', 'es', 'fr', 'it', 'pt', 'code', 'name')


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
    recording_web = serializers.FileField(
        read_only=True,
        source='get_web_recording',
    )
    dialect = serializers.PrimaryKeyRelatedField(
        queryset=Dialect.objects.all(),
    )
    place = PlaceSerializer(write_only=True)
    languages = serializers.PrimaryKeyRelatedField(
        queryset=Language.objects.all(),
        many=True,
    )
    age = serializers.PrimaryKeyRelatedField(
        queryset=AgeCategory.objects.all(),
    )
    recording_original_datasource = serializers.SerializerMethodField()    

    class Meta():
        model = Recording
        fields = (
            'id',
            'url',
            'recording',
            'recording_web',
            'recording_original_datasource',
            'name',
            'email',
            'phone',
            'relation_to_speaker',
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
            'relation_to_speaker': {
                'write_only': True,
                'required': False,
            }, 
            'generation': {
                'write_only': True,
                'required': False,
            },
            'origin': {                
                'required': False,
            },
            'migrated': {                
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
        # Italian speakers are always first generation even if not migrated
        if place.country.code == 'IT':
            validated_data['generation'] = Recording.FIRST_GEN
        return super().create(validated_data)

    def get_recording_original_datasource(self, recording):
        if recording.recording_original_datasource == '':
            return None
        else:
           return recording.recording_original_datasource    


class PlaceRecordingsSerializer(serializers.ModelSerializer):
    country = serializers.SlugRelatedField(
        slug_field='code',
        queryset=Country.objects.all(),
    )
    recordings = serializers.SerializerMethodField()

    # credits to https://stackoverflow.com/a/25313145/
    def get_recordings(self, place):
        recordings = Recording.objects.filter(place=place, public=True)
        serializer = RecordingSerializer(
            many=True,
            instance=recordings,
            # context is needed for its 'request' field because of
            # RecordingSerializer's HyperlinkedIdentityFields
            context=self.context,
        )
        return serializer.data

    class Meta:
        model = Place
        fields = (
            'id',
            'placeID',
            'name',
            'latitude',
            'longitude',
            'country',
            'recordings',
        )
