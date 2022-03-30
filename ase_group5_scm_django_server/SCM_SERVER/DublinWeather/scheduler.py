from datetime import datetime
from apscheduler.schedulers.background import BackgroundScheduler
from .views import weatherToFirebase


def start_schedulers():
    weatherScheduler = BackgroundScheduler()
    print("####################Started BUS Scheduler#######################")
    weatherScheduler.add_job(weatherToFirebase, 'interval', days=1)
    print("*******************End BUS Scheduler**************************")
    weatherScheduler.start()
