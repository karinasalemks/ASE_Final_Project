import haversine as hs
from math import sin, cos, sqrt, atan2, radians
import json
from ..models import stops_dict, bus_stops

DUBLIN_BUS_BASELINE_CO2_EMISSION_UNIT = 1450
LUAS_BASELINE_CO2_EMISSION_UNIT = 14640


class TRIP:

    def __init__(self, trip_id, entity, start_time, stop_sequences):
        self.trip_id = trip_id
        self.entity = entity
        self.start_time = start_time
        self.stop_sequences = stop_sequences
        self.co2Emission = self.estimate_co2_emission(stop_sequences)

    # method to convert bike model to json
    # https://stackoverflow.com/questions/3768895/how-to-make-a-class-json-serializable :P
    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True, indent=4)

    def calculateTripDistance(self, stop_sequences):
        total_trip_distance = 0
        for index in range(0, len(stop_sequences) - 2):
            source_coords = stop_sequences[index].coordinates
            destination_coords = stop_sequences[index + 1].coordinates

            # Get the coordinates of the source and destination bus stops
            # source_coords = (source_lat, source_long)
            # destination_coords = (destination_lat, destination_long)

            # Calculate the distance and add it to total_trip_distance
            # print('source ===========>',source_coords)
            # print('destination ==========>',destination_coords)
            total_trip_distance += self.calculate_distance(source_coords, destination_coords)
        return total_trip_distance

    def calculate_distance(self, source_coords, destination_coords):
        distance = abs(hs.haversine(source_coords, destination_coords))
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
                # create tuple of "<route_id>,<stop_id>,<direction>"
                key_tuple = (route_id, stop_id, dir)
                # stop_seq_id = stopSequence['StopSequence']
                # check if the create key tuple exits in the stops_dict
                if (key_tuple in stops_dict):
                    stop_dict_value = stops_dict[key_tuple]
                    # bus_arrival_time = stop_dict_value[0]
                    # bus_departure_time = stop_dict_value[1]
                    bus_stop = bus_stops[stop_id]
                    stop_seq = STOPSEQUENCE(
                       bus_stop.latitude,bus_stop.longitude)
                    stop_seq_list.append(stop_seq)
                else:
                    print("Error - Key tuple is not there: ", key_tuple)
                    continue
            except IndexError:
                continue
        return stop_seq_list
