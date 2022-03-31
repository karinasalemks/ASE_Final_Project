from datetime import datetime
from apscheduler.schedulers.background import BackgroundScheduler
from .views import getLuasData


def start_schedulers():
    schedulers = BackgroundScheduler()
    print("####################Started Scheduler#######################")
    schedulers.add_job(getLuasData, 'interval', seconds=15)
    print("*******************End Scheduler**************************")
    schedulers.start()