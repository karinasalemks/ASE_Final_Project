from django.shortcuts import render
from DataTransformer.views import transformData
from static import Endpoints as apiSource
from django.http import HttpResponse
import requests, json
from static.firebaseInitialization import db

# #Bus stop static data needs to be pushed only once to firebase.
# busStopData = requests.get(apiSource.DUBLIN_BUSES_API['busStops'])
# busStopData = json.loads(busStopData.text)
# # data = []
# # for busStop in busStopData:
# #     data.append(busStop)
# result = {'data':[busStopData]}
# db.collection(u'DublinBus').document(u'busStops').set(result)
# print("Bus Batch Transaction Complete..")

# Create your views here.
def busTripsToFirebase():
    print("*************** Fetching Dublin Bus API ****************")
    busResponse = requests.get(apiSource.DUBLIN_BUSES_API['source'])
    print("*************** Fetching Done ****************")
    if busResponse.status_code == 200 or busResponse.status_code == 201:
        #busData = transformData(source="DUBLIN_BUS", apiResponse=json.loads(busResponse.text))
        busData = json.loads(busResponse.text)
        print(len(busData))
        result = {'data':busData}
        db.collection(u'DublinBus').document(u'trips').set(result)
    else:
        print("Response code:-", busResponse.status_code)

