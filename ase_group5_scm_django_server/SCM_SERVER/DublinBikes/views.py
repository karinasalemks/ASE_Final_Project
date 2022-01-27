from django.shortcuts import render
from django.http import HttpResponse
import requests,json
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import numpy as np
import pandas as pd
from predictionApp.views import predictionDublinBikes

# replace the key with the groups private key
cred_obj = credentials.Certificate('static\privateKey.json')
default_app = firebase_admin.initialize_app(cred_obj)
db =firestore.client()


def bikeAvailability():
    response = requests.get('https://data.smartdublin.ie/dublinbikes-api/last_snapshot/')
    print("*************** Fetching Dublin Bike's API ****************")

    # Fetching recent observations from csv for predictions.
    recent_df = pd.read_csv('static\StationID_Recent_Observations.csv')
    recent_df.set_index('stationID', inplace=True)

    r =response.json()
    bikesCollectionRef= db.collection(u'DublinBikes')
    batch = db.batch()
    i=0
    for values in r:
        currentStation = {}
        station_id = str(values['station_id'])
        currentStation['station_id'] = station_id
        # Replaced with the predictions below...
        #availableBikes = [values['available_bikes'] for i in range(25)]
        #currentStation['available_bikes'] = availableBikes
        currentStation['available_bike_stands'] = values['available_bike_stands']
        currentStation['harvest_time'] = values['harvest_time']
        currentStation['latitude'] = values['latitude']
        currentStation['longitude'] = values['longitude']
        currentStation['station_name'] = values['name']
        currentStation['station_status'] = values['status']

        # Update CSV file with most recent observation
        # First read the last 20 observations, then convert to numpy array
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

        currentDocRef = bikesCollectionRef.document(station_id)
        batch.update(currentDocRef, currentStation)


    batch.commit()
    print("Batch Transaction Complete..")

    # Save new Observations CSV
    i+=1
    print("##########################################"+str(i))
    recent_df.to_csv('static\StationID_Recent_Observations.csv')
    
    # for structure we can pass the time stamp and station id in document
    
    #return HttpResponse('Test Sucessful')
