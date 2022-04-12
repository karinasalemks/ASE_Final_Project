from . import Endpoints
from django.http import JsonResponse
from Server_DataTransformer.views import transformData, transformWeatherData
from django.http import HttpResponse
import requests
import json
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

