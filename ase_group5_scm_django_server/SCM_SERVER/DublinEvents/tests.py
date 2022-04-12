from django.test import TestCase
import pandas as pd
from geopy import distance

newport_ri = (41.49008, -71.312796)
cleveland_oh = (41.499498, -81.695391)
print(distance.distance(newport_ri, cleveland_oh).miles)
538.39044536

wellington = (-41.32, 174.81)
salamanca = (40.96, -5.50)
print(distance.distance(wellington, salamanca).km)


Venue_Loc = pd.read_csv('static/venue_loc.csv')
Bus_Stops = pd.read_csv(r'C:\Users\kevin\Documents\Masters\Advanced Software Engineering\ASE_Final_Project\ase_group5_scm_django_server\DataServer\Server_DataTransformer\StaticFiles\stops.csv')
# Create your tests here.

print(Venue_Loc)
venue_names = []
venue_near_stops = []
venue_near_stops_ids, venue_near_stops_names,venue_near_stops_distances = [], [], []

for row in Venue_Loc.iterrows():
    venue = row[1]['name']
    venue_lat_long = (float(row[1]['lat']),float(row[1]['long']))

    venue_names.append(venue)
    venue_near_stops.append([])
    venue_near_stops_ids.append([])
    venue_near_stops_names.append([])
    venue_near_stops_distances.append([])


print(venue_names)
print(venue_names.index('RDS Arena'))

nearest_stop_count=0
for row in Bus_Stops.iterrows():

    stop_id = row[1]['stop_id']
    stop_name = row[1]['stop_name']
    stop_lat_long = (float(row[1]['stop_lat']),float(row[1]['stop_lon']))

    for row in Venue_Loc.iterrows():
        venue = row[1]['name']
        venue_lat_long = (float(row[1]['lat']),float(row[1]['long']))
        stop_distance = distance.distance(stop_lat_long, venue_lat_long).km

        if stop_distance <= 1:
            #print("Distance from ", stop_name, " to ", venue, " is ", stop_distance, "km")
            venue_near_stops[row[0]].append([stop_id,stop_name,stop_lat_long[0],stop_lat_long[1],stop_distance])
            venue_near_stops_ids[row[0]].append(stop_id)
            venue_near_stops_names[row[0]].append(stop_name)
            venue_near_stops_distances[row[0]].append(stop_distance)
            nearest_stop_count += 1

print(venue_near_stops)
nearest_stop_dict = {}

for index, venue in enumerate(venue_names):

    nearest_stop_dict[venue] = {}
    for stop_index, stop in enumerate(venue_near_stops[index]):
        stop_dict = {'stop_id':stop[0],'stop_name': stop[1],'stop_lat':stop[2],'stop_long' : stop[3],'stop_dist': stop[4]}
        # stop_id = stop[0]
        # stop_name = stop[1]
        # stop_lat = stop[2]
        # stop_long = stop[3]
        # stop_dist = stop[4]
        nearest_stop_dict[venue][stop_index] = stop_dict


print(nearest_stop_dict)

import json

# python dictionary with key value pairs


# create json object from dictionary
json = json.dumps(nearest_stop_dict)

# open file for writing, "w"
f = open("static/nearest_stop_dict.json","w")

# write json object to file
f.write(json)

# close file
f.close()