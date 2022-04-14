from datetime import datetime
from apscheduler.schedulers.background import BackgroundScheduler
from .views import busTripsToFirebase


def start_schedulers():
    busScheduler = BackgroundScheduler()
    busScheduler.add_job(busTripsToFirebase, 'interval', minutes=15)
    busScheduler.start()
