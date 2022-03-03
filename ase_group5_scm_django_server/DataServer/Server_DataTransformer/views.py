from django.shortcuts import render
from Server_DataTransformer.Server_DataModel.serverBikeModel import BikeModel
import pandas as pd
import json
import requests
from Server_DataTransformer.Server_DataModel.busModel import TRIP, STOPSEQUENCE
from Server_DataTransformer.Server_DataModel.eventsModel import EVENTS

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
                    stop_seq_list = STOPSEQUENCE.getStopSequenceList(
                        stopTimeSequences, route_id, trip_update_split[4])
                except KeyError:
                    print("Error, no 'StopTimeUpdate' field", tripUpdate)
                    continue
        except IndexError:
            print("Error in TripId, no routes, trip Id: ", trip_update_split)
            continue
        trip_obj = TRIP(trip_id, bus_entity, start_time, stop_seq_list)
        jsonObj = trip_obj.toJSON()
        # trip_obj.estimateCO2()
        trips_list.append(jsonObj)
    return trips_list


def transformLUASData(apiResponse):
    return "Success"


def transformEventsData(inputData):
    api_response = inputData["_embedded"]["events"]
    events_list = []
    try:
        #For each event in the reponse data, read and get the event details to for EVENTS objects
        for event in api_response:
            event_name = event["name"]
            event_date_time = event["dates"]["start"]["dateTime"]
            event_location_name = event["_embedded"]["venues"][0]["name"]
            event_location_longitude = event["_embedded"]["venues"][0]["location"]["longitude"]
            event_location_latitude = event["_embedded"]["venues"][0]["location"]["latitude"]
            event_data = EVENTS(event_name, event_date_time, event_location_name, event_location_longitude, event_location_latitude)
            events_list.append(event_data)
    except KeyError:
        print("Error, no key field", KeyError)
    return events_list


DataTransformer = {
    "DUBLIN_BIKES": transformBikeData,
    "DUBLIN_BUS": transformBUSData,
    "DUBLIN_LUAS": transformLUASData,
    "DUBLIN_EVENTS": transformEventsData,
}


def transformData(source="DUBLIN_BIKES", apiResponse={}, isPrimarySource=True):
    return DataTransformer.get(source)(apiResponse, isPrimarySource)
