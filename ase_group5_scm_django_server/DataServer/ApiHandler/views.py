from urllib import response
from django.shortcuts import render

from . import Endpoints
from django.http import JsonResponse
from Server_DataTransformer.views import transformData
from django.http import HttpResponse
import requests
import json
from Server_DataTransformer.Server_DataModel import serverBikeModel
from Server_DataTransformer.models import  bus_stops,stopList


def getBikeData(request):
    # dummy logic to determine the api source, it needs a change
    endpoint = None
    isPrimarySource = None
    from random import randint
    value = randint(1, 100)
    if value % 2 == 0:
        endpoint = Endpoints.DUBLIN_BIKES_API['PRIMARY']
        isPrimarySource = True
    else:
        endpoint = Endpoints.DUBLIN_BIKES_API['SECONDARY']
        isPrimarySource = False

    # getting data from bike live data source
    response = requests.get(endpoint)
    dublinBikesData = transformData(
        apiResponse=response.json(), isPrimarySource=isPrimarySource)
    return JsonResponse(dublinBikesData, safe=False)


def getBusData(request):
    response = requests.get(
        Endpoints.DUBLIN_BUSES_API["PRIMARY"], headers={
            # Request headers
            'Cache-Control': 'no-cache',
            'x-api-key': 'e6f06c8f344e454f872d48addd6c23c6',
        })
    if (response.status_code == 200):
        dublinBusData = transformData(
            source="DUBLIN_BUS", apiResponse=response.json())

        print("bus data done")
        return JsonResponse(dublinBusData, safe=False)
    else:
        print(response.status_code)

def getBusStops(request):
    returnStopList = {}
    for eachBusStop in stopList:
        stop_id,busStopJson = eachBusStop.toJSON()
        returnStopList[stop_id]=busStopJson
    return JsonResponse(returnStopList, safe = False)
