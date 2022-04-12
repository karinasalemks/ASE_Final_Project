from . import Endpoints
from django.http import JsonResponse
from Server_DataTransformer.views import transformData, transformWeatherData
from django.http import HttpResponse
import requests
import json
import datetime
from datetime import timedelta
from Server_DataTransformer.Server_DataModel import serverBikeModel
from datetime import datetime,timezone,timedelta
from Server_DataTransformer.Server_DataModel.busModel import bus_stops
from Server_DataTransformer.Server_DataModel.luasModel import luas_stops
import xml.etree.ElementTree as ET
import time


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

#static data for luas
luasStops = ["The Point","Spencer Dock","Mayor Square - NCI","George's Dock","Connolly","BusÃ¡ras","Abbey Street","Jervis",
	"Four Courts","Smithfield","Museum","Heuston","James's","Fatima","Rialto","Suir Road","Goldenbridge","Drimnagh","Fettercairn",
	"Cheeverstown","Citywest Campus","Fortunestown","Saggart","Depot","Broombridge","Cabra","Phibsborough","Grangegorman","Broadstone - DIT",
	"Dominick","Parnell","O'Connell - Upper","O'Connell - GPO","Marlborough","Westmoreland","Trinity","Dawson","St. Stephen's Green","Harcourt",
	"Charlemont","Ranelagh","Beechwood","Cowper","Milltown","Windy Arbour","Dundrum","Balally","Kilmacud","Stillorgan","Sandyford",
	"Central Park","Glencairn","The Gallops","Leopardstown Valley","Ballyogan Wood","Racecourse","Carrickmines","Brennanstown","Laughanstown",
	"Cherrywood","Brides Glen","Blackhorse","Bluebell","Kylemore","Red Cow","Kingswood","Belgard","Cookstown","Hospital","Tallaght"];
	
luasStopsCode = ["TPT","SDK","MYS","GDK","CON","BUS","ABB","JER","FOU","SMI","MUS","HEU","JAM","FAT","RIA","SUI",
	"GOL","DRI","FET","CVN","CIT","FOR","SAG","DEP","BRO","CAB","PHI","GRA","BRD","DOM","PAR","OUP","OGP","MAR","WES","TRY","DAW",
	"STS","HAR","CHA","RAN","BEE","COW","MIL","WIN","DUN","BAL","KIL","STI","SAN","CPK","GLE","GAL","LEO","BAW","RCC","CCK","BRE",
        "LAU","CHE","BRI","BLA","BLU","KYL","RED","KIN","BEL","COO","HOS","TAL"]

def getLuasData(request):
    start = time.time()
    luasData = {}
    for stop_code in luasStopsCode:
        print(f"[INFO] Gathering Data from Luas Station: {stop_code}")
        request_url = f"http://luasforecasts.rpa.ie/xml/get.ashx?action=forecast&stop={stop_code}&encrypt=false"
        response = requests.get(request_url)
        root = ET.fromstring(response.text)
        luasStop = {}
        for x in root:
            if x.tag == "message":
                luasStop['line'] = x.text.split(" ")[0]
            else:
                direction = x.attrib['name']
                if direction == "Inbound":
                    inboundTrams = []
                    for y in x:
                        inboundTrams.append(y.attrib)
                    luasStop["inboundTrams"] = inboundTrams
                    luasStop["inboundTramsCount"] = len(inboundTrams)
                else:
                    outboundTrams = []
                    for y in x:
                        outboundTrams.append(y.attrib)
                    luasStop["outboundTrams"] = outboundTrams
                    luasStop["outboundTramsCount"] = len(outboundTrams)
        luasData[stop_code] = luasStop
    end = time.time()
    print(f"[INFO] Time taken to gather Luas Data: {end-start}")
    return JsonResponse(luasData, safe = False)

def getLuasStops(request):
    return JsonResponse(luas_stops, safe = False)

def getTimeStrings():
    startTime = datetime.now(timezone.utc)
    numDays = timedelta(days=30)
    endTime = startTime + numDays
    startTimeString = startTime.strftime("%Y-%m-%dT%H:%M")
    endTimeString = endTime.strftime("%Y-%m-%dT") + "23:59"
    return startTimeString, endTimeString

def aggregateWeatherForecast(request):
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
        return response.json()
    else:
        print(response.status_code)
        return []

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

