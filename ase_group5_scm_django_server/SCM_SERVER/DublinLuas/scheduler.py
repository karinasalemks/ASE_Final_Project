from datetime import datetime
from apscheduler.schedulers.background import BackgroundScheduler
from .views import getLuasData, getLuasStopsData


def start_schedulers():
    schedulers = BackgroundScheduler()
    schedulers.add_job(getLuasData, 'interval', minutes=15)
    schedulers.start()