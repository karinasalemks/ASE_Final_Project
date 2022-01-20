from datetime import datetime
from apscheduler.schedulers.background import BackgroundScheduler
from .views import test


def start():
    scheduler = BackgroundScheduler()
    scheduler.add_job(test,'interval',minutes=5)
    scheduler.start()