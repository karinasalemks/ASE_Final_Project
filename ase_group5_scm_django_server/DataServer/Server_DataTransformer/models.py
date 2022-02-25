# from pickle import STOP
import pandas as pd
from .Server_DataModel.busModel import BUS_STOP, STOPSEQUENCE, TRIP
import csv

# from StaticFiles

stopsTimeFilePath = "Server_DataTransformer/StaticFiles/stop_times.csv"
inputFilePath = "Server_DataTransformer/StaticFiles/stops.csv"


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
        # trip_id,arrival_time,departure_time,stop_id
        included_cols = [0, 1, 2, 3]
        for row in csv_reader:
            content = list(row[i] for i in included_cols)
            # split the trip_id to get route_id and direction
            content_split = content[0].split(".")
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
