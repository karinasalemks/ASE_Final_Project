from django.shortcuts import render
from django.http import HttpResponse
import requests, json
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import numpy as np
from static import Endpoints as apiSource
import json
from DataTransformer.views import transformData
from .bike_swap_suggestions import *
from static.firebaseInitialization import db
import time

# this method call should be done only once before the server starts
bike_station_distance_matrix = proprocessBikeStationData()


def bikeAvailability():
    start = time.time()
    print("*************** Fetching Dublin Bike's API ****************")
    response = requests.get(apiSource.DUBLIN_BIKES_API['source'])

    if response.status_code == 200 or response.status_code == 201:
        # prediction engine call and transforming data
        bikeStationData = transformData(apiResponse=json.loads(response.text))
        # Once the data is transformed we need to generate swap suggestions:
        # swap_suggestions = {"swap_suggestions":generate_swap_suggestions(bikeStationData,bike_station_distance_matrix)}
        bikesCollectionRef = db.collection(u'DublinBikesHistoricalData')
        pushDict = {"histor_occ_Data":{
            db.field_path("April 07, 2022"): 0.2,
            db.field_path("April 08, 2022"): 0.4,
            db.field_path("April 09, 2022"): 0.6,
            db.field_path("April 10, 2022"): 0.8,
            db.field_path("April 11, 2022"): 0.7,
        }
        }
        batch = db.batch()
        # Update Bike station Data
        for stationData in bikeStationData:
            currentDocRef = bikesCollectionRef.document(stationData.station_id)
            doc = currentDocRef.get()
            if doc.exists:
                batch.update(currentDocRef, pushDict)
            else:
                batch.set(currentDocRef, pushDict)

        #   #Update Swap Suggestions
        #   swap_suggestions_collection = db.collection(u'Bikes_Swap_Suggestions')
        #   swap_suggestions_document = swap_suggestions_collection.document("bike_swap_suggestions")
        #   doc = swap_suggestions_document.get()
        #   if doc.exists:
        #       batch.update(swap_suggestions_document,swap_suggestions)
        #   else:
        #       batch.set(swap_suggestions_document,swap_suggestions)

        batch.commit()
        print("Batch Transaction Complete..")
    else:
        print("Response code:", response.status_code)
    end = time.time()
    print(end - start)
