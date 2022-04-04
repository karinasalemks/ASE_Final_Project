from datetime import datetime
from apscheduler.schedulers.background import BackgroundScheduler
from .views import getLuasData, getLuasStopsData


def start_schedulers():
    schedulers = BackgroundScheduler()
    print("####################Started Scheduler#######################")
    schedulers.add_job(getLuasData, 'interval', minutes=15)
    # use this to insert luasstopdata once and then comment it.
    # schedulers.add_job(getLuasStopsData, 'interval',minutes = 15)
    print("*******************End Scheduler**************************")
    schedulers.start()