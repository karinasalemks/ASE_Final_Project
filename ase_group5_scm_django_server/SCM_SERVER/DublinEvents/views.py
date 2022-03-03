from django.shortcuts import render
from django.http import HttpResponse
import requests, json
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import numpy as np
from . import Endpoints as apiSource
import json
import os, time

# replace the key with the groups private key
privateKeyPath = os.path.join(os.getcwd(), 'static')
privateKeyPath = os.path.join(privateKeyPath, 'privateKey.json')
cred_obj = credentials.Certificate(privateKeyPath)

default_app = firebase_admin.initialize_app(cred_obj)
db = firestore.client()


def eventHappenings():
    start = time.time()
    print("*************** Fetching Dublin Bike's API ****************")
    response = requests.get(apiSource.DUBLIN_EVENTS_API['source'])

    if response.status_code == 200 or response.status_code == 201:
        eventsData = response
        eventsCollectionRef = db.collection(u'DublinEvents')
        batch = db.batch()
        for eventData in eventsData:
            #using even name as the doc reference
            currentDocRef = eventsCollectionRef.document(eventData.name)
            batch.update(currentDocRef, eventData.to_dict())

        batch.commit()
        print("Batch Transaction Complete..")
    else:
        print("Response code:-", response.status_code)
    end = time.time()
    print(end - start)
