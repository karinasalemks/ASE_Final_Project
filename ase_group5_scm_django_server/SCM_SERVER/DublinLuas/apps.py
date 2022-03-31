from django.apps import AppConfig


class DublinluasConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'DublinLuas'

    #changed for scheduling 
    def ready(self):
        from DublinLuas import scheduler
        scheduler.start_schedulers()