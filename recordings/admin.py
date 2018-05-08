from django.contrib import admin

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
    readonly_fields = ('recording_web', 'recording_original_name')
    fieldsets = (
        (None, {
            'fields': (
                ('status', 'public'),
                'recording',
                'recording_web',
                'recording_original_name',
            ),
        }),
        ('Information about the uploader', {
            'fields': ('name', 'email', 'phone'),
        }),
        ('Information about the recording and the speaker', {
            'fields': (
                'dialect',
                'place',
                'languages',
                ('age', 'sex'),
                'education',
                'generation',
                ('origin', 'migrated'),
            ),
        }),
    )
    filter_horizontal = ('languages',)
    list_filter = (
        'status',
        'public',
        ('dialect', admin.RelatedOnlyFieldListFilter),
        ('place', admin.RelatedOnlyFieldListFilter),
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
        'uploader',
        'dialect',
        'place',
        'status',
        'public',
    )

    def uploader(self, instance):
        """
        Return the name of the uploader from the Recording instance.

        This is basically a trick to rename the column in `list_display`,
        see https://docs.djangoproject.com/en/1.8/ref/contrib/admin/#django.contrib.admin.ModelAdmin.list_display.
        """
        return instance.name

    def formerly(self, instance):
        """ A renaming trick just like `uploader`. """
        return instance.recording_original_name


admin.site.register(Dialect, LocalizedNamesAdmin)
admin.site.register(Recording, RecordingAdmin)
admin.site.register(Language, LocalizedNamesAdmin)
admin.site.register(Place, PlaceAdmin)
admin.site.register(Country, LocalizedNamesAdmin)
