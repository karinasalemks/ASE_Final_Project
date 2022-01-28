from django.shortcuts import render
from django.http import HttpResponse
import requests, json
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import numpy as np

import os
from API_Handler.views import getAPIEndpoint
from DataTransformer.views import transformData

# replace the key with the groups private key
privateKeyPath = os.path.join(os.getcwd(),'static')
privateKeyPath = os.path.join(privateKeyPath,'privateKey.json')
cred_obj = credentials.Certificate(privateKeyPath)

default_app = firebase_admin.initialize_app(cred_obj)
db = firestore.client()

def bikeAvailability():
    endpoint,isPrimarySource = getAPIEndpoint("DUBLIN_BIKES")
    print("*************** Fetching Dublin Bike's API ****************")


    response = requests.get(endpoint)
    
    if response.status_code == 200 or response.status_code == 201:
      apiResponse =response.json()
      #Data Transformed to a custom model here
      bikeStationData = transformData(apiResponse=apiResponse,isPrimarySource=isPrimarySource)

      bikesCollectionRef= db.collection(u'DublinBikes')
      batch = db.batch()
      for stationData in bikeStationData:
          currentDocRef = bikesCollectionRef.document(stationData.station_id)
        
          recent_list = np.fromstring(recent_df.loc[int(station_id)].recentObservations[1:-1], sep=' ', dtype='int64')
          
          updated_list = np.empty(20, dtype='int64')
          updated_list[:19] = recent_list[1:]
          updated_list[19] = values['available_bikes']
          recent_df.loc[int(station_id)].recentObservations = updated_list
          
          #call predictions  the code for prediction is in predictionApp.views
          predictions= predictionDublinBikes(updated_list,int(values['station_id'])).tolist()
          
          # At zero index we have inserted the current availability of bike
          predictions.insert(0,values['available_bikes'])         
          currentStation['available_bikes'] = predictions  
                  
          batch.update(currentDocRef, stationData.to_dict())
                    
      batch.commit()
      print("Batch Transaction Complete..")
      
      # Save updated Observations CSV
      recent_df.to_csv('static\StationID_Recent_Observations.csv')
      
     else:
      print("Response code:", response.status_code)
