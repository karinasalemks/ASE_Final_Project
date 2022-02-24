"""
Input: Processed Data from GTFS API.  
Output: Co2 Estimation for each route based on the distance of that route. 
#TODO: Need to include this as an TRIP class method once migrated to Data Server
"""
import haversine as hs
from math import sin, cos, sqrt, atan2, radians

#BASELINE CO2 Emission constants [Unit: g/KM]
#Source: https://www.irishtimes.com/life-and-style/motors/surprise-carbon-offenders-1.765821#:~:text=Based%20on%20945%20passengers%20travelling,1%2C450g%2Fkm%20of%20CO2.
DUBLIN_BUS_BASELINE_CO2_EMISSION_UNIT = 1450
LUAS_BASELINE_CO2_EMISSION_UNIT = 14640

def estimate_co2_emission(self):
    total_trip_distance = calculateTripDistance(self.stop_sequences)
    return total_trip_distance * DUBLIN_BUS_BASELINE_CO2_EMISSION_UNIT

def calculateTripDistance(stop_sequences):
    total_trip_distance = 0
    for index in range(0,len(stop_sequences)-2):
        source = stop_sequences[index]
        destination = stop_sequences[index+1]

        #Get the coordinates of the source and destination bus stops
        source_coords = (source.bus_stop.latitude,source.bus_stop.longitude)
        destination_coords = (destination.bus_stop.latitude,destination.bus_stop.longitude)

        #Calculate the distance and add it to total_trip_distance
        total_trip_distance += calculate_distance(source_coords,destination_coords)
    return total_trip_distance

def calculateDistance(source_coords,destination_coords):
    radius_of_earth = 6373
    distance_longitude = radians(destination_coords[1]) - radians(source_coords[1])
    distance_latitude = radians(destination_coords[0]) - radians(source_coords[0])
    arc_distance = sin(distance_latitude / 2) ** 2 + cos(source_coords[0]) * cos(destination_coords[1]) * sin(distance_longitude / 2)**2
    c = 2 * atan2(sqrt(arc_distance), sqrt(1 - arc_distance))
    distance = radius_of_earth * c
    return round(distance,2)

def calculate_distance(source_coords,destination_coords):
    distance = abs(hs.haversine(source_coords,destination_coords))
    return round(distance,2)
        