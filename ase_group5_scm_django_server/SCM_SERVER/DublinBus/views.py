from django.shortcuts import render
from DataTransformer.views import transformData
from static import Endpoints as apiSource
from django.http import HttpResponse
import requests, json
from static.firebaseInitialization import db
from LoadBalancer.views import send_request


# Create your views here.
def busTripsToFirebase():
    print("*************** Fetching Dublin Bus API ****************")
    busResponse = send_request(apiSource.DUBLIN_BUSES_API['source'])
    print("*************** Fetching Done ****************")
    if busResponse.status_code == 200 or busResponse.status_code == 201:
        busData = json.loads(busResponse.text)

        # Update trips collection
        result = {'data': busData['trips_list']}
        db.collection(u'DublinBus').document(u'trips').set(result)

        # Update part_of_trips collection
        result = {'data': busData['part_of_trips']}
        db.collection(u'DublinBus').document(u'busiest_stops').set(result)
    else:
        print("Response code:-", busResponse.status_code)
