from django.apps import AppConfig

from .signals import connect_signals


class RecordingsConfig(AppConfig):
    name = 'recordings'
    
    def ready(self):
        """
        Initialization of the Recordings application (Django style).
        
        Documentation:
        https://docs.djangoproject.com/en/1.8/ref/applications/#django.apps.AppConfig.ready
        https://docs.djangoproject.com/en/1.8/topics/signals/#connecting-receiver-functions
        """
        connect_signals(self)
