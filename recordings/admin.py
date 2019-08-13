# Register your models here.
from django.contrib import admin

from .models import Dialect, Recording, Language, Place, Country


class LocalizedNamesAdmin(admin.ModelAdmin):
    list_display = ('en', 'it', 'es', 'fr', 'pt')


class PlaceAdmin(admin.ModelAdmin):
    readonly_fields = ('placeID', 'name', 'latitude', 'longitude', 'country')
    list_filter = (('country', admin.RelatedOnlyFieldListFilter),)
    search_fields = ('name',)
    list_display = ('name', 'country', 'latitude', 'longitude', 'placeID')


class RecordingAdmin(admin.ModelAdmin):
    """ Customizations to the default ModelAdmin. """
    readonly_fields = ('recording_web', 'recording_original_name', 'uploader_relation_to_speaker')
    filter_horizontal = ('languages',)
    list_filter = (
        'status',
        'public',
        ('dialect', admin.RelatedOnlyFieldListFilter),
        ('place', admin.RelatedOnlyFieldListFilter),
        'place__country',
        'sex',
        'education',
        'generation',
        ('age', admin.RelatedOnlyFieldListFilter),
        'migrated',
    )
    search_fields = ('recording', 'name', 'email', 'phone', 'origin')
    list_display = (
        'id',
        'formerly',
        'dialect',
        'place',
        'status',
        'public',
    )

    def formerly(self, instance):
        """
        Return the former name of the file from the Recording instance.

        This is basically a trick to rename the column in `list_display`,
        see https://docs.djangoproject.com/en/1.8/ref/contrib/admin/#django.contrib.admin.ModelAdmin.list_display.
        """
        return instance.recording_original_name

    def get_fieldsets(self, request, obj=None):
        """ Customization of fieldsets, since some users do not have permission to see contact details of the uploader """
        general_part = (None, {
                    'fields': (
                        ('status', 'public'),
                        'recording',
                        'recording_web',
                        'recording_original_name',
                        'recording_original_datasource',
                    ),
                })
        optional_part_uploader_details =  self.get_uploader_section(request.user, obj)
        recording_speaker_part = ('Information about the recording and the speaker', {
                    'fields': (
                        'dialect',
                        'place',
                        'languages',
                        ('age', 'sex'),
                        'education',
                        'generation',
                        ('origin', 'migrated'),
                    ),
                })
        return (general_part, recording_speaker_part) if not optional_part_uploader_details else (general_part, optional_part_uploader_details, recording_speaker_part)

    def get_uploader_section(self, user, obj):
        if (user.has_perm('recordings.view_uploader_contactdetails')):
            return ('Information about the uploader', {
                        'fields': ('name', 'email', 'phone', 'uploader_relation_to_speaker'),
                    })
        else:
            return None


admin.site.register(Dialect, LocalizedNamesAdmin)
admin.site.register(Recording, RecordingAdmin)
admin.site.register(Language, LocalizedNamesAdmin)
admin.site.register(Place, PlaceAdmin)
admin.site.register(Country, LocalizedNamesAdmin)
