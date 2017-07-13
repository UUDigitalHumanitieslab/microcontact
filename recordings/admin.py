from django.contrib import admin

# Register your models here.
from django.contrib import admin

from .models import Dialect, Recording

admin.site.register(Dialect)
admin.site.register(Recording)
