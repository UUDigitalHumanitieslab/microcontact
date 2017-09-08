from django.contrib import admin

# Register your models here.
from django.contrib import admin

from .models import Dialect, Recording, Language, Place, Country


class PlaceAdmin(admin.ModelAdmin):
    readonly_fields = ('placeID', 'name', 'latitude', 'longitude', 'country')
    list_filter = (('country', admin.RelatedOnlyFieldListFilter),)


class RecordingAdmin(admin.ModelAdmin):
    """ Customizations to the default ModelAdmin. """
    readonly_fields = ('recording_web',)
    fieldsets = (
        (None, {
            'fields': (('status', 'public'), 'recording', 'recording_web'),
        }),
        ('Information about the uploader', {
            'fields': ('name', 'email', 'phone'),
        }),
        ('Information about the recording and the speaker', {
            'fields': (
                'dialect',
                'place',
                ('age', 'sex'),
                'education',
                'generation',
                ('origin', 'migrated'),
            ),
        }),
    )
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


admin.site.register(Dialect)
admin.site.register(Recording, RecordingAdmin)
# admin.site.register(Language)
admin.site.register(Place, PlaceAdmin)
admin.site.register(Country)
