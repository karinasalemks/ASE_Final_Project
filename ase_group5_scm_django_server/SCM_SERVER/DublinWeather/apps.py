from django.apps import AppConfig


class DublinweatherConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'DublinWeather'


 #changed for scheduling
    def ready(self):
        from DublinWeather import scheduler
        scheduler.start_schedulers()