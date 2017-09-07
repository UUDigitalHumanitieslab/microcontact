from django.contrib import admin

# Register your models here.
from django.contrib import admin

from .models import Dialect, Recording, Language, Place, Country


class PlaceAdmin(admin.ModelAdmin):
    readonly_fields = ('placeID', 'name', 'latitude', 'longitude', 'country')


class RecordingAdmin(admin.ModelAdmin):
    """ Customizations to the default ModelAdmin. """
    fields = (
        'status',
        'dialect',
        'public',
        'place',
        'recording',
    )


admin.site.register(Dialect)
admin.site.register(Recording, RecordingAdmin)
# admin.site.register(Language)
admin.site.register(Place, PlaceAdmin)
admin.site.register(Country)
