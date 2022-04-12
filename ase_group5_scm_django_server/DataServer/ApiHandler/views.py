from urllib import response
from django.shortcuts import render

from . import Endpoints
from django.http import JsonResponse
from Server_DataTransformer.views import transformData
from django.http import HttpResponse
import requests
import json
import datetime
from datetime import timedelta
from Server_DataTransformer.Server_DataModel import serverBikeModel


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

def get_event_id(i):
    """returns the event id for respective event place"""
    switcher={
            "Aviva":"KovZ9177Tn7",
            "3Arena":"KovZ9177WYV",
            "National Stadium":"KovZ9177TZf",
            "Bord Gais Energy Theatre":"KovZ917AZa7",
            "Gaiety Theatre":"KovZ9177XT0"
            }
    return switcher.get(i,"Invalid Event")

def getEventsData(request):
    print("**** getEventsData")
    #List of events that are taken for usage
    popular_events = ["Aviva", "3Arena", "National Stadium", "Bord Gais Energy Theatre", "Gaiety Theatre"]
    #get the current datetime and convert it to a format required for API request
    today = datetime.datetime.now()
    today_time = today.strftime("%H:%M:%S")
    today_date = today.strftime("%Y-%m-%d")
    formated_date_time = today_date+'T'+today_time+'Z'
    #get the datetime after 30 days and convert it to a format required for API request
    month_later = datetime.datetime.now() + timedelta(days=30)
    month_later_time = month_later.strftime("%H:%M:%S")
    month_later_date = month_later.strftime("%Y-%m-%d")
    month_later_formated_date_time = month_later_date + 'T' + month_later_time + 'Z'
    #list that contains all the details of the event happenings
    dublinEventsData = []
    #For every event location get the api response and create the event details
    for place in popular_events:
        id = get_event_id(place)
        response = requests.get(Endpoints.DUBLIN_EVENTS_API["PRIMARY"] + get_event_id(place) + "&startDateTime=" + formated_date_time+ "&endDateTime=" + month_later_formated_date_time + "&apikey=Od2QOTqrUGW7CPeiRXSgzGv3zGAquRAL", headers={
            # Request headers
            'Cache-Control': 'no-cache',
            'x-api-key': 'Od2QOTqrUGW7CPeiRXSgzGv3zGAquRAL',
            })
        if (response.status_code == 200):
            dublinEventsData.append(transformData(source="DUBLIN_EVENTS", apiResponse=response.json()))
        else:
            print(response.status_code)
    print(dublinEventsData)
    print("Get Events data done")
    return JsonResponse(dublinEventsData, safe=False)
        
