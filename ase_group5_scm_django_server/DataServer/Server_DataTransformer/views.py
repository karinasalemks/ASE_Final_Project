from Server_DataTransformer.Server_DataModel.serverBikeModel import BikeModel
import pandas as pd
from Server_DataTransformer.Server_DataModel.busModel import *

# Create your views here.
def transformBikeData(inputData, isPrimarySource):
    result = {}
    stationData = []

    if isPrimarySource:
        for apiResponse in inputData:
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
    stop_seq_list = []
    for trip in bus_delays_list:
        tripUpdate = trip['TripUpdate']
        trip_id = trip['Id']
        # splitting the trip id to get the route id and direction
        trip_update_split = trip_id.split(".")
        try:
            route_id = trip_update_split[2]

            #Filter route associated with dublin bus, else return. 
            if route_id not in routes_list:
                continue

            # splitting the route id to get the bus entity (bus number)
            route_split = route_id.split("-")
            bus_entity = route_split[1]
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
            print("Error in TripId, no routes, trip Id: ", trip_id,trip_update_split)
            continue

        if len(stop_seq_list) >= 0:
            trip_obj = TRIP(trip_id, bus_entity, start_time, stop_seq_list)
            jsonObj = trip_obj.toJSON()
            trips_list.append(jsonObj)
    part_of_trips = generate_part_of_trips(trips_list)
    result = {}
    result["trips_list"] = trips_list
    result["part_of_trips"] = part_of_trips
    return result

def generate_part_of_trips(trips_list):
    part_of_trips = {}
    for trip in trips_list:
        stop_sequence = trip['stop_sequences']
        for stop_id in stop_sequence:
            if stop_id in part_of_trips:
                part_of_trips[stop_id] += 1
            else:
                part_of_trips[stop_id] = 1
    part_of_trips = sorted(part_of_trips.items(), key=lambda x: x[1], reverse=True)
    result = {}
    for item in part_of_trips:
        stop_id = item[0]
        value = item[1]
        if value >= 10:
         result[stop_id] = value
    return result


def transformLUASData(apiResponse):
    return "Success"

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
