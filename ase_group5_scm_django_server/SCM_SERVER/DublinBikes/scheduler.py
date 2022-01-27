from datetime import datetime
from apscheduler.schedulers.background import BackgroundScheduler
from .views import bikeAvailability


def start():
    schedulers = BackgroundScheduler()
    schedulers.add_job(bikeAvailability,'interval',seconds=40)
    schedulers.start()
