from . import Endpoints
from django.http import JsonResponse
from Server_DataTransformer.views import transformData, transformWeatherData
from django.http import HttpResponse
import requests
import json
from Server_DataTransformer.Server_DataModel import serverBikeModel
from datetime import datetime, timezone
from Server_DataTransformer.Server_DataModel.busModel import bus_stops


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
        Endpoints.DUBLIN_BUSES_API["PRIMARY"], headers=Endpoints.DUBLIN_BUS_HEADER)
    if (response.status_code == 200):
        dublinBusData = transformData(
            source="DUBLIN_BUS", apiResponse=response.json())
        return JsonResponse(dublinBusData, safe=False)
    else:
        print(response.status_code)

def getBusStops(request):
    returnStopList = {}
    for bus_stop in bus_stops.items():
        stop_id,busStopJson = bus_stop[1].toJSON()
        returnStopList[stop_id]=busStopJson
    return JsonResponse(returnStopList, safe = False)

def getTimeStrings():
    startTime = datetime.now(timezone.utc)
    numDays = datetime.timedelta(days=30)
    endTime = startTime + numDays
    startTimeString = startTime.strftime("%Y-%m-%dT%H:%M")
    endTimeString = endTime.strftime("%Y-%m-%dT") + "23:59"
    return startTimeString, endTimeString


def aggregateWeatherForecast():
    weather_warning = getWeatherWarning()
    weather_forecast = getWeatherForecast()
    weather_data = transformWeatherData(weatherXML=weather_forecast, weatherWarning=weather_warning)
    return JsonResponse(weather_data, safe=False)


def getWeatherForecast():
    # can only get weather data 10 days into the future
    fromTime, toTime = getTimeStrings()
    response = requests.get(Endpoints.WEATHER_FORECAST_API["PRIMARY"] + fromTime + "&to=" + toTime)
    if (response.status_code == 200):
        return response
    else:
        print(response.status_code)
        return ""


def getWeatherWarning():
    response = requests.get(Endpoints.WEATHER_WARNING_API["PRIMARY"])
    if (response.status_code == 200):
        return response
    else:
        print(response.status_code)
        return []
