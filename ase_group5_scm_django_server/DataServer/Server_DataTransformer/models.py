# from pickle import STOP
import pandas as pd
import csv
import json
import haversine as hs
# from StaticFiles

stopsTimeFilePath = "Server_DataTransformer/StaticFiles/stop_times.csv"
inputFilePath = "Server_DataTransformer/StaticFiles/stops.csv"


class BUS_STOP:
    """Read stops.txt file and create objects"""

    def __init__(self, stop_id, stop_name, stop_lat, stop_lon,distance_from_spire):
        self.stop_id = stop_id
        self.name = stop_name
        self.latitude = stop_lat
        self.longitude = stop_lon
        self.distance_from_spire = distance_from_spire

    def toJSON(self):
        bus_stop_data = {}
        bus_stop_data['stop_id'] = self.stop_id
        #bus_stop_data['name'] = self.name
        bus_stop_data['latitude'] = self.latitude
        bus_stop_data['longitude'] = self.longitude
        bus_stop_data['distance_from_spire'] = self.distance_from_spire
        return self.stop_id,bus_stop_data

def readSTOPSFile(inputFilePath):
    data = pd.read_csv(inputFilePath)
    list_of_stops = {}
    for index, row in data.iterrows():
        stop_id = row['stop_id']
        stop_name = row['stop_name'].split(", stop ")[0]
        stop_lat = row['stop_lat']
        stop_lon = row['stop_lon']
        distance_from_spire = calculate_distance_from_spire(stop_lat,stop_lon)
        if distance_from_spire <= 10:
            newStop = BUS_STOP(stop_id, stop_name, stop_lat, stop_lon,distance_from_spire)
            list_of_stops[stop_id] = newStop
    return list_of_stops

def calculate_distance_from_spire(stop_lat,stop_lon):
    spireLocation = (53.34995225574133, -6.260263222038029)
    result = hs.haversine((stop_lat,stop_lon),spireLocation)
    return result

def createStops(inputFilePath):
    data = pd.read_csv(inputFilePath)
    print("Insinde create stop method. Stop calling me all the time.")
    stops_list = []
    for index, row in data.iterrows():
        stop_id = row['stop_id']
        stop_name = row['stop_name'].split(", stop ")[0]
        stop_lat = row['stop_lat']
        stop_lon = row['stop_lon']
        distance_from_spire = calculate_distance_from_spire(stop_lat,stop_lon)
        if distance_from_spire <= 10:
            newStop = BUS_STOP(stop_id, stop_name, stop_lat, stop_lon,distance_from_spire)
            stops_list.append(newStop)
    return stops_list

stopList = createStops(inputFilePath)
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
    return stops_dict


stops_dict = readStopTimesFile(stopsTimeFilePath)
