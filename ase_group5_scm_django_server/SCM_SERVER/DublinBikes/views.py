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

from DataTransformer.views import transformData

# replace the key with the groups private key
privateKeyPath = os.path.join(os.getcwd(), 'static')
privateKeyPath = os.path.join(privateKeyPath, 'privateKey.json')
cred_obj = credentials.Certificate(privateKeyPath)

default_app = firebase_admin.initialize_app(cred_obj)
db = firestore.client()


def bikeAvailability():
    start = time.time()
    print("*************** Fetching Dublin Bike's API ****************")
    response = requests.get(apiSource.DUBLIN_BIKES_API['source'])

    if response.status_code == 200 or response.status_code == 201:
        # prediction engine call and transforming data
        bikeStationData = transformData(apiResponse=json.loads(response.text))
        bikesCollectionRef = db.collection(u'DublinBikes')
        batch = db.batch()
        for stationData in bikeStationData:
            currentDocRef = bikesCollectionRef.document(stationData.station_id)
            batch.update(currentDocRef, stationData.to_dict())
        batch.commit()
        print("Bikes Batch Transaction Complete..")
    else:
        print("Response code:-", response.status_code)
    end = time.time()
    print(end - start)


def busTripsToFirebase():
    print("*************** Fetching Dublin Bus API ****************")
    busResponse = requests.get(apiSource.DUBLIN_BUSES_API['source'])
    print("*************** Fetching Done ****************")
    if busResponse.status_code == 200 or busResponse.status_code == 201:
        busData = transformData(source="DUBLIN_BUS", apiResponse=json.loads(busResponse.text))
        print("final bus data ============================>", busData)
        # busCollectionRef = db.collection(u'DublinBus')
        # batch = db.batch()
        # for Data in busData:
        #     currentDocRef = busCollectionRef.document(Data.trip_id)
        #     batch.update(currentDocRef, Data.to_dict())
        # batch.commit()
        print("Bus Batch Transaction Complete..")
    else:
        print("Response code:-", busResponse.status_code)
