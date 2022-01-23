from datetime import datetime
from apscheduler.schedulers.background import BackgroundScheduler
from .views import bikeAvailability


def start():
    scheduler = BackgroundScheduler()
    scheduler.add_job(bikeAvailability,'interval',seconds=40)
    scheduler.start()
