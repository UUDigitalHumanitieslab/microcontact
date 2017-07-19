from django.contrib import admin

# Register your models here.
from django.contrib import admin

from .models import Dialect, Recording, Language, Place, Country


class RecordingAdmin(admin.ModelAdmin):
    """ Customizations to the default ModelAdmin. """
    fields = (
        'status',
        'dialect',
        'is_public_recording',
        'place',
        'recording',
    )


admin.site.register(Dialect)
admin.site.register(Recording, RecordingAdmin)
admin.site.register(Language)
admin.site.register(Place)
admin.site.register(Country)
