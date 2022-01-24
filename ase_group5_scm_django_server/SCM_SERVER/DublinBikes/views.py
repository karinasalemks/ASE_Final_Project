from django.shortcuts import render
from django.http import HttpResponse
import requests, json
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# replace the key with the groups private key
cred_obj = credentials.Certificate('static\privateKey.json')
default_app = firebase_admin.initialize_app(cred_obj)
db = firestore.client()


def bikeAvailability():
    response = requests.get('https://data.smartdublin.ie/dublinbikes-api/last_snapshot/')
    print("*************** Fetching Dublin Bike's API ****************")
    r = response.json()
    bikesCollectionRef = db.collection(u'DublinBikes')
    batch = db.batch()
    for values in r:
        currentStation = {}
        station_id = str(values['station_id'])
        currentStation['station_id'] = station_id
        availabeBikes = [values['available_bikes'] for i in range(25)]
        currentStation['available_bikes'] = availabeBikes
        currentStation['available_bike_stands'] = values['available_bike_stands']
        currentStation['harvest_time'] = values['harvest_time']
        currentStation['latitude'] = values['latitude']
        currentStation['longitude'] = values['longitude']
        currentStation['station_name'] = values['name']
        currentStation['station_status'] = values['status']
        currentStation['station_occupancy'] = availabeBikes / values['bike_stands']

        currentDocRef = bikesCollectionRef.document(station_id)
        batch.update(currentDocRef, currentStation)
    batch.commit()
    print("Batch Transaction Complete..")

    # for structure we can pass the time stamp and station id in document

    # return HttpResponse('Test Sucessful')
