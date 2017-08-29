from django.apps import AppConfig

from .signals import connect_signals


class RecordingsConfig(AppConfig):
    name = 'recordings'
    
    def ready(self):
        connect_signals(self)
