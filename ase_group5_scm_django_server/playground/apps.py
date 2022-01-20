from django.apps import AppConfig


class PlaygroundConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'playground'
    

    #changed for scheduling 
    def ready(self):
        from playground import updater
        updater.start() 