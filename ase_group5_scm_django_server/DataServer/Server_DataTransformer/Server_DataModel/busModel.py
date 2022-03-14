import haversine as hs
from math import sin, cos, sqrt, atan2, radians
import json
from ..models import stops_dict, bus_stops

DUBLIN_BUS_BASELINE_CO2_EMISSION_UNIT = 1450
LUAS_BASELINE_CO2_EMISSION_UNIT = 14640


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
                # create tuple of "<route_id>,<stop_id>,<direction>"
                key_tuple = (route_id, stop_id, dir)
                # stop_seq_id = stopSequence['StopSequence']
                # check if the create key tuple exits in the stops_dict
                if (key_tuple in stops_dict):
                    stop_dict_value = stops_dict[key_tuple]
                    # bus_arrival_time = stop_dict_value[0]
                    # bus_departure_time = stop_dict_value[1]
                    if stop_id in bus_stops:
                        bus_stop = bus_stops[stop_id]
                        _,data = bus_stop.toJSON()
                        # stop_seq = STOPSEQUENCE(
                        # bus_stop.latitude,bus_stop.longitude)
                        stop_seq_list.append(data['stop_id'])
                else:
                    print("Error - Key tuple is not there: ", key_tuple)
                    continue
            except IndexError:
                continue
        return stop_seq_list
