from django.apps import AppConfig


class DublinbusConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'DublinBus'


 #changed for scheduling
    def ready(self):
        from DublinBus import scheduler
        scheduler.start_schedulers()