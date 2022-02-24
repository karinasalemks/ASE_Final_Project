from pickle import STOP
import pandas as pd
from Server_DataModel.busModel import BUS_STOP, STOPSEQUENCE, TRIP
import csv
import json
import requests

stopsTimeFilePath = "StaticFiles/stop_times.csv"
inputFilePath = "StaticFiles/stops.csv"


def readSTOPSFile(inputFilePath):
    data = pd.read_csv(inputFilePath)
    list_of_stops = {}
    for index, row in data.iterrows():
        stop_id = row['stop_id']
        stop_name = row['stop_name'].split(", stop ")[0]
        stop_lat = row['stop_lat']
        stop_lon = row['stop_lon']
        newStop = BUS_STOP(stop_id, stop_name, stop_lat, stop_lon)
        list_of_stops[stop_id] = newStop
    return list_of_stops


bus_stops = readSTOPSFile(inputFilePath)


def readStopTimesFile(inputFilePath):
    """Create a stops dictionary from the stop_times.csv"""
    stops_dict = {}
    with open(inputFilePath) as stop_times:
        csv_reader = csv.reader(stop_times)
        included_cols = [0, 1, 2, 3]  # trip_id,arrival_time,departure_time,stop_id
        for row in csv_reader:
            content = list(row[i] for i in included_cols)
            content_split = content[0].split(".")  # split the trip_id to get route_id and direction
            try:
                # Tuple of "<route_id>,<stop_id>,<direction>"
                key_tuple = (content_split[2], content[3], content_split[4])
                # Value of [<arrival_time>, <departure_time>]
                value = [content[1], content[2]]
                stops_dict[key_tuple] = value
            except IndexError:
                continue
    print("stops dict done")
    return stops_dict


stops_dict = readStopTimesFile(stopsTimeFilePath)


def getBusData():
    headers = {
        # Request headers
        'Cache-Control': 'no-cache',
        'x-api-key': 'e6f06c8f344e454f872d48addd6c23c6',
    }

    url = "https://gtfsr.transportforireland.ie/v1/?format=json"
    response = requests.get(url, headers=headers)
    if (response.status_code == 200):
        api_response = response.json()
        bus_data = api_response["Entity"]
        print("bus data done")
        return bus_data
    else:
        print(response.status_code)
        return ''


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
                stop_seq = STOPSEQUENCE(stop_seq_id, bus_stop, bus_arrival_time, bus_departure_time)
                stop_seq_list.append(stop_seq)
            else:
                print("Error - Key tuple is not there: ", key_tuple)
                continue
        except IndexError:
            continue
    return stop_seq_list


def getBusTrips():
    """returns a list of TRIP objects"""
    # read bus data from request api
    bus_delays_list = getBusData()
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
                    stop_seq_list = getStopSequenceList(stopTimeSequences, route_id, trip_update_split[4])
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


getBusTrips()
