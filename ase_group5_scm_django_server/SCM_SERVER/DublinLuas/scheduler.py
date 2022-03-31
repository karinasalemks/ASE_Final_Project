from datetime import datetime
from apscheduler.schedulers.background import BackgroundScheduler
from .views import getLuasData


def start_schedulers():
    schedulers = BackgroundScheduler()
    print("####################Started Scheduler#######################")
    schedulers.add_job(getLuasData, 'interval', minutes=5)
    print("*******************End Scheduler**************************")
    schedulers.start()