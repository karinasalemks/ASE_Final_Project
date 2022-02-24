import haversine as hs
from math import sin, cos, sqrt, atan2, radians

DUBLIN_BUS_BASELINE_CO2_EMISSION_UNIT = 1450
LUAS_BASELINE_CO2_EMISSION_UNIT = 14640


class TRIP:

    def __init__(self, trip_id, entity, start_time, stop_sequences):
        self.trip_id = trip_id
        self.entity = entity
        self.start_time = start_time
        self.stop_sequences = stop_sequences

    def calculateTripDistance(self, stop_sequences):
        total_trip_distance = 0
        for index in range(0, len(stop_sequences) - 2):
            source = stop_sequences[index]
            destination = stop_sequences[index + 1]

            # Get the coordinates of the source and destination bus stops
            source_coords = (source.bus_stop.latitude, source.bus_stop.longitude)
            destination_coords = (destination.bus_stop.latitude, destination.bus_stop.longitude)

            # Calculate the distance and add it to total_trip_distance
            total_trip_distance += self.calculate_distance(source_coords, destination_coords)
        return total_trip_distance

    def calculate_distance(self, source_coords, destination_coords):
        distance = abs(hs.haversine(source_coords, destination_coords))
        return round(distance, 2)

    def estimate_co2_emission(self, stop_sequences):
        total_trip_distance = self.calculateTripDistance(stop_sequences)
        return total_trip_distance * DUBLIN_BUS_BASELINE_CO2_EMISSION_UNIT


class BUS_STOP:
    """Read stops.txt file and create objects"""

    def __init__(self, stop_id, stop_name, stop_lat, stop_lon):
        self.stop_id = stop_id
        self.name = stop_name
        self.latitude = stop_lat
        self.longitude = stop_lon


class STOPSEQUENCE:
    """Read data from stop_times.txt and 
    aggregate with stop time update data received from API"""

    def __init__(self, stop_sequence_id, bus_stop, arrival_time, departure_time):
        self.stop_sequence_id = stop_sequence_id
        self.bus_stop = bus_stop
        self.arrival_time = arrival_time
        self.departure_time = departure_time
