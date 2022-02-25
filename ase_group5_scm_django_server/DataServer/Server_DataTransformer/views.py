from django.shortcuts import render
from Server_DataTransformer.Server_DataModel.serverBikeModel import BikeModel
import pandas as pd
import json
from models import stops_dict, bus_stops
import requests
from Server_DataModel.busModel import TRIP, STOPSEQUENCE


# Create your views here.
def transformBikeData(inputData, isPrimarySource):
    result = {}
    stationData = []

    if isPrimarySource:
        for apiResponse in inputData:
            print(apiResponse["station_id"])
            result['station_id'] = str(apiResponse['station_id'])
            result['bike_stands'] = apiResponse['bike_stands']
            result['available_bikes'] = apiResponse['available_bikes']
            result['available_bike_stands'] = apiResponse['available_bike_stands']
            result['harvest_time'] = apiResponse['harvest_time']
            result['latitude'] = apiResponse['latitude']
            result['longitude'] = apiResponse['longitude']
            result['station_name'] = apiResponse['name']
            result['station_status'] = apiResponse['status']
            # occupancy list has to be added
            # prediction has to done in the app
            bikeData = BikeModel(result)
            stationData.append(bikeData.toJSON())
    else:
        for apiResponse in inputData:
            result["station_id"] = str(apiResponse["number"])
            result['available_bikes'] = apiResponse['available_bikes']
            result['bike_stands'] = apiResponse['bike_stands']
            result['available_bike_stands'] = apiResponse['available_bike_stands']
            timestamp = apiResponse['last_update']
            timestamp_ms = pd.to_datetime(timestamp, unit='ms')
            timestamp_formatted = timestamp_ms.strftime('%Y-%m-%dT%H:%M:%S')
            result['harvest_time'] = timestamp_formatted
            result['latitude'] = str(apiResponse['position']['lat'])
            result['longitude'] = str(apiResponse['position']['lng'])
            result['station_name'] = apiResponse['name']
            result['station_status'] = apiResponse['status']
            # occupancy list has to be added
            # prediction has to be added
            bikeData = BikeModel(result)
            stationData.append(bikeData.toJSON())
    return stationData


def transformLUASData(apiResponse):
    return "Success"


def transformBUSData(bus_data, isPrimarySource):
    """returns a list of TRIP objects"""
    # read bus data from request api
    bus_delays_list = bus_data["Entity"]
    trips_list = []
    for trip in bus_delays_list:
        tripUpdate = trip['TripUpdate']
        trip_id = trip['Id']
        # splitting the trip id to get the route id and direction
        trip_update_split = trip_id.split(".")
        try:
            route_id = trip_update_split[2]
            # splitting the route id to get the bus entity (bus number)
            route_split = route_id.split("-")
            bus_entity = route_split[2]
            trip_entity = tripUpdate['Trip']
            start_time = trip_entity['StartTime']
            """ 
            ScheduleRelationship has 3 values: 'Scheduled', 'Skipped', 'Canceled'
            """
            if (trip_entity['ScheduleRelationship'] == 'Scheduled'):
                try:
                    stopTimeSequences = tripUpdate['StopTimeUpdate']
                    # trip_update_split[4] is the direction of the trip
                    stop_seq_list = getStopSequenceList(
                        stopTimeSequences, route_id, trip_update_split[4])
                except KeyError:
                    print("Error, no 'StopTimeUpdate' field", tripUpdate)
                    continue
        except IndexError:
            print("Error in TripId, no routes, trip Id: ", trip_update_split)
            continue
        trip_obj = TRIP(trip_id, bus_entity, start_time, stop_seq_list)
        # trip_obj.estimateCO2()
        trips_list.append(trip_obj)
    return trips_list


# def getBusData():
#     headers = {
#         # Request headers
#         'Cache-Control': 'no-cache',
#         'x-api-key': 'e6f06c8f344e454f872d48addd6c23c6',
#     }

#     url = "https://gtfsr.transportforireland.ie/v1/?format=json"
#     response = requests.get(url, headers=headers)
#     if (response.status_code == 200):
#         api_response = response.json()
#         bus_data = api_response["Entity"]
#         print("bus data done")
#         return bus_data
#     else:
#         print(response.status_code)
#         return ''


def getStopSequenceList(stopTimeSequences, route_id, dir):
    """returns a list of STOPSEQUENCE objects for each trip"""
    stop_seq_list = []
    for stopSequence in stopTimeSequences:
        try:
            stop_id = stopSequence['StopId']
            # create tuple of "<route_id>,<stop_id>,<direction>"
            key_tuple = (route_id, stop_id, dir)
            stop_seq_id = stopSequence['StopSequence']
            # check if the create key tuple exits in the stops_dict
            if (key_tuple in stops_dict):
                stop_dict_value = stops_dict[key_tuple]
                bus_arrival_time = stop_dict_value[0]
                bus_departure_time = stop_dict_value[1]
                bus_stop = bus_stops[stop_id]
                stop_seq = STOPSEQUENCE(
                    stop_seq_id, bus_stop, bus_arrival_time, bus_departure_time)
                stop_seq_list.append(stop_seq)
            else:
                print("Error - Key tuple is not there: ", key_tuple)
                continue
        except IndexError:
            continue
    return stop_seq_list


def transformEventsData(apiResponse):
    return "Success"


DataTransformer = {
    "DUBLIN_BIKES": transformBikeData,
    "DUBLIN_BUS": transformBUSData,
    "DUBLIN_LUAS": transformLUASData,
    "DUBLIN_EVENTS": transformEventsData,
}


def transformData(source="DUBLIN_BIKES", apiResponse={}, isPrimarySource=True):
    return DataTransformer.get(source)(apiResponse, isPrimarySource)
