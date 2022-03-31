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


def transformEventsData(inputData, isPrimarySource):
    api_response = inputData["_embedded"]["events"]
    events_list = []
    events_list_loc = []
    events_header = {}
    try:
        events_header["event_location_name"] = api_response[0]["_embedded"]["venues"][0]["name"]
        events_header["event_location_longitude"] = api_response[0]["_embedded"]["venues"][0]["location"]["longitude"]
        events_header["event_location_latitude"] = api_response[0]["_embedded"]["venues"][0]["location"]["latitude"]
        for event in api_response:
            date = event["dates"]["start"]["dateTime"]
            event_name = event["name"]
            events_list_loc.append([date, event_name])
        
        events_header["events"] = dict(events_list_loc)
        events_header_Data = EVENTS(events_header)
        events_list.append(events_header_Data.toJSON())
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
