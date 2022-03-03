from datetime import datetime
from apscheduler.schedulers.background import BackgroundScheduler
from .views import bikeAvailability
from .views import busTripsToFirebase


def start_schedulers():
    schedulers = BackgroundScheduler()
    print("####################Started Scheduler#######################")
    schedulers.add_job(bikeAvailability, 'interval', minutes=5)
    schedulers.add_job(busTripsToFirebase, 'interval', minutes=5)
    print("*******************End Scheduler**************************")
    schedulers.start()
