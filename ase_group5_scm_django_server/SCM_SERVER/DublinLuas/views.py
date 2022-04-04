from django.shortcuts import render
from django.shortcuts import render
from DataTransformer.views import transformData
from static import Endpoints as apiSource
from django.http import HttpResponse
import requests, json
from static.firebaseInitialization import db
from LoadBalancer.views import send_request
# Create your views here.
def getLuasData():
    print("*************** Fetching Dublin Luas API ****************")
    luasResponse = send_request(apiSource.DUBLIN_LUAS_API['source'])
    print("*************** Fetching Done ****************")
    if luasResponse.status_code == 200 or luasResponse.status_code == 201:
        #busData = transformData(source="DUBLIN_BUS", apiResponse=json.loads(busResponse.text))
        luasData = json.loads(luasResponse.text)

        #Update trips collection
        result = {'data':luasData}
        db.collection(u'DublinLuas').document(u'luasTrams').set(result)

    else:
        print("Response code:-", luasResponse.status_code)

def getLuasStopsData():
    print("*************** Fetching Dublin Luas Stops API ****************")
    luasResponse = send_request(apiSource.DUBLIN_LUAS_API['stops'])
    print("*************** Fetching Done ****************")
    if luasResponse.status_code == 200 or luasResponse.status_code == 201:
        luasData = json.loads(luasResponse.text)
        #Update trips collection
        result = {'data':luasData}
        db.collection(u'DublinLuas').document(u'luasStops').set(result)

    else:
        print("Response code:-", luasResponse.status_code)

