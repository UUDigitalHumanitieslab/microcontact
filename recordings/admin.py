from django.contrib import admin

# Register your models here.
from django.contrib import admin

from .models import Dialect, Contribution, Language, Place, Country


class PlaceAdmin(admin.ModelAdmin):
    readonly_fields = ('placeID', 'name', 'latitude', 'longitude', 'country')


class ContributionAdmin(admin.ModelAdmin):
    """ Customizations to the default ModelAdmin. """
    fields = (
        'status',
        'dialect',
        'is_public_recording',
        'place',
        'recording',
    )


admin.site.register(Dialect)
admin.site.register(Contribution, ContributionAdmin)
# admin.site.register(Language)
admin.site.register(Place, PlaceAdmin)
admin.site.register(Country)
