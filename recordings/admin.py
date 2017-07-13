from django.contrib import admin

# Register your models here.
from django.contrib import admin

from .models import Dialect, Recording, Language, Place, Country

admin.site.register(Dialect)
admin.site.register(Recording)
admin.site.register(Language)
admin.site.register(Place)
admin.site.register(Country)
