from django.apps import AppConfig


class DublinbikesConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'DublinBikes'
    

    #changed for scheduling 
    def ready(self):
        from DublinBikes import views
        views.bikeAvailability()
        scheduler.start_schedulers()