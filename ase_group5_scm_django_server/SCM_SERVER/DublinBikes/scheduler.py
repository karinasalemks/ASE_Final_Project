from datetime import datetime
from apscheduler.schedulers.background import BackgroundScheduler
from .views import bikeAvailability


def start_schedulers():
    schedulers = BackgroundScheduler()
    print("####################Started Scheduler#######################")
    schedulers.add_job(bikeAvailability, 'interval', seconds=15)
    print("*******************End Scheduler**************************")
    schedulers.start()
