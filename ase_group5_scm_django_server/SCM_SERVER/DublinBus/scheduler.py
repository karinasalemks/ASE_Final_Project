from datetime import datetime
from apscheduler.schedulers.background import BackgroundScheduler
from .views import busTripsToFirebase


def start_schedulers():
    busScheduler = BackgroundScheduler()
    print("####################Started BUS Scheduler#######################")
    busScheduler.add_job(busTripsToFirebase, 'interval', seconds=500)
    print("*******************End BUS Scheduler**************************")
    busScheduler.start()
