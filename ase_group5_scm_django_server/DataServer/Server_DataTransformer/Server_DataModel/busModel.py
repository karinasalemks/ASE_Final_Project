import haversine as hs
import pandas as pd
import haversine as hs
import csv

stopsTimeFilePath = "Server_DataTransformer/StaticFiles/stop_times.csv"
inputFilePath = "Server_DataTransformer/StaticFiles/stops.csv"
routesFilePath = "Server_DataTransformer/StaticFiles/routes.csv"

DUBLIN_BUS_BASELINE_CO2_EMISSION_UNIT = 1450
LUAS_BASELINE_CO2_EMISSION_UNIT = 14640

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
        bus_stop_data['name'] = self.name
        bus_stop_data['latitude'] = self.latitude
        bus_stop_data['longitude'] = self.longitude
        bus_stop_data['distance_from_spire'] = self.distance_from_spire
        return self.stop_id,bus_stop_data

class TRIP:

    def __init__(self, trip_id, entity, start_time, stop_sequences):
        self.trip_id = trip_id
        self.busNo = entity
        self.start_time = start_time
        self.stop_sequences = stop_sequences
        self.co2Emission = self.estimate_co2_emission(stop_sequences)

    # method to convert bike model to json
    # https://stackoverflow.com/questions/3768895/how-to-make-a-class-json-serializable :P
    def toJSON(self):
        result = {}
        result["trip_id"] = self.trip_id
        result["busNo"] = self.busNo
        result["start_time"] = self.start_time
        result["stop_sequences"] = self.stop_sequences
        result["co2Emission"] = self.co2Emission
        return result

    def calculateTripDistance(self, stop_sequences):
        total_trip_distance = 0
        for index in range(0, len(stop_sequences) - 2):
            source_bus_stop_id = stop_sequences[index]
            destination_bus_stop_id = stop_sequences[index + 1]
            source_bus_stop = (bus_stops[source_bus_stop_id].latitude,bus_stops[source_bus_stop_id].longitude)
            destination_bus_stop = (bus_stops[destination_bus_stop_id].latitude,bus_stops[destination_bus_stop_id].longitude)
            total_trip_distance += self.calculate_distance(source_bus_stop,destination_bus_stop)
        return total_trip_distance

    def calculate_distance(self, source_bus_stop,destination_bus_stop):
        distance = abs(hs.haversine(source_bus_stop,destination_bus_stop))
        return round(distance, 2)

    def estimate_co2_emission(self, stop_sequences):
        total_trip_distance = self.calculateTripDistance(stop_sequences)
        return total_trip_distance * DUBLIN_BUS_BASELINE_CO2_EMISSION_UNIT

class STOPSEQUENCE:
    """Read data from stop_times.txt and 
    aggregate with stop time update data received from API"""

    def __init__(self, lat,long):
        # self.stop_sequence_id = stop_sequence_id
        # self.bus_stop = bus_stop
        # self.arrival_time = arrival_time
        # self.departure_time = departure_time
        self.coordinates = (lat,long)

    def getStopSequenceList(stopTimeSequences, route_id, dir):
        """returns a list of STOPSEQUENCE objects for each trip"""
        stop_seq_list = []
        for stopSequence in stopTimeSequences:
            try:
                stop_id = stopSequence['StopId']
                if stop_id in bus_stops:
                    bus_stop = bus_stops[stop_id]
                    _,data = bus_stop.toJSON()
                    stop_seq_list.append(data['stop_id'])
                else:
                    print("Error - Key tuple is not there: ", stop_id)
                    continue
            except IndexError:
                continue
        return stop_seq_list

def readSTOPSFile(inputFilePath):
    data = pd.read_csv(inputFilePath)
    list_of_stops = {}
    for index, row in data.iterrows():
        stop_id = row['stop_id']
        stop_name = row['stop_name'].split(", stop ")[0]
        stop_lat = row['stop_lat']
        stop_lon = row['stop_lon']
        distance_from_spire = calculate_distance_from_spire(stop_lat,stop_lon)
        if distance_from_spire <= 50:
            newStop = BUS_STOP(stop_id, stop_name, stop_lat, stop_lon,distance_from_spire)
            list_of_stops[stop_id] = newStop
    return list_of_stops

def calculate_distance_from_spire(stop_lat,stop_lon):
    spireLocation = (53.34995225574133, -6.260263222038029)
    result = hs.haversine((stop_lat,stop_lon),spireLocation)
    return result

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

def readROUTESFile(inputFilePath):
    data = pd.read_csv(inputFilePath)
    routes_list = {}
    for index, row in data.iterrows():
        route_id = row['route_id']
        routes_list[route_id] = True
    return routes_list

def read_static_files():    
    print("[INFO] Loading Stops")
    bus_stops = readSTOPSFile(inputFilePath)

    print("[INFO] Loading Stops Times...")
    stops_dict = readStopTimesFile(stopsTimeFilePath)

    print("[INFO] Loading Routes...")
    routes_list = readROUTESFile(routesFilePath)

    return bus_stops,stops_dict,routes_list

bus_stops,stops_dict,routes_list = read_static_files()