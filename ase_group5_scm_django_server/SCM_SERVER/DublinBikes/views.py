from django.shortcuts import render
from django.http import HttpResponse
import requests, json
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import numpy as np

import os,time

from API_Handler.views import getAPIEndpoint
from DataTransformer.views import transformData
from .bike_swap_suggestions import *

# replace the key with the groups private key
privateKeyPath = os.path.join(os.getcwd(),'static')
privateKeyPath = os.path.join(privateKeyPath,'privateKey.json')
cred_obj = credentials.Certificate(privateKeyPath)

default_app = firebase_admin.initialize_app(cred_obj)
db = firestore.client()

#this method call should be done only once before the server starts
bike_station_distance_matrix = proprocessBikeStationData()

def bikeAvailability():
    start=time.time()
    endpoint,isPrimarySource = getAPIEndpoint("DUBLIN_BIKES")
    print("*************** Fetching Dublin Bike's API ****************")
    
    response = requests.get(endpoint)
    
    if response.status_code == 200 or response.status_code == 201:
      apiResponse =response.json()
      #Data Transformed to a custom model here
      bikeStationData = transformData(apiResponse=apiResponse,isPrimarySource=isPrimarySource)
      #Once the data is transformed we need to generate swap suggestions:
      swap_suggestions = {"swap_suggestions":generate_swap_suggestions(bikeStationData,bike_station_distance_matrix)}
      bikesCollectionRef= db.collection(u'DublinBikes')
      batch = db.batch()

      #Update Bike station Data
      for stationData in bikeStationData:
          currentDocRef = bikesCollectionRef.document(stationData.station_id) 
          batch.update(currentDocRef, stationData.to_dict())

      #Update Swap Suggestions
      swap_suggestions_document = bikesCollectionRef.document("bike_swap_suggestions")
      batch.update(swap_suggestions_document,swap_suggestions)
                    
      batch.commit()
      print("Batch Transaction Complete..")
    else:
      print("Response code:", response.status_code)
    end=time.time()
    print(end-start)   