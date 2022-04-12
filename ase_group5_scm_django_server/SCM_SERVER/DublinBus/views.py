from django.shortcuts import render
from DataTransformer.views import transformData
from static import Endpoints as apiSource
from django.http import HttpResponse
import requests, json
from static.firebaseInitialization import db
from LoadBalancer.views import send_request
#Bus stop static data needs to be pushed only once to firebase.
# busStopData = requests.get(apiSource.DUBLIN_BUSES_API['busStops'])
# print(busStopData)
# busStopData = json.loads(busStopData.text)
# data = []
# # for busStop in busStopData:
# #     data.append(busStop)
# result = {'data':[busStopData]}
# print("Number of stops after filetering: "+str(len(busStopData)))
# db.collection(u'DublinBus').document(u'busStops').set(result)
# print("Bus Batch Transaction Complete..")

# Create your views here.
def busTripsToFirebase():
    print("*************** Fetching Dublin Bus API ****************")
    busResponse = send_request(apiSource.DUBLIN_BUSES_API['source'])
    print("*************** Fetching Done ****************")
    if busResponse.status_code == 200 or busResponse.status_code == 201:
        #busData = transformData(source="DUBLIN_BUS", apiResponse=json.loads(busResponse.text))
        busData = json.loads(busResponse.text)

        #Update trips collection
        result = {'data':busData['trips_list']}
        db.collection(u'DublinBus').document(u'trips').set(result)

        #Update part_of_trips collection
        result = {'data':busData['part_of_trips']}
        db.collection(u'DublinBus').document(u'busiest_stops').set(result)
    else:
        print("Response code:-", busResponse.status_code)

