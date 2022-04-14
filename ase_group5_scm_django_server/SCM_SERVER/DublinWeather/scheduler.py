from datetime import datetime
from apscheduler.schedulers.background import BackgroundScheduler
from .views import weatherToFirebase


def start_schedulers():
    weatherScheduler = BackgroundScheduler()
    weatherScheduler.add_job(weatherToFirebase, 'interval', days=1)
    weatherScheduler.start()
