import pandas as pd
import haversine as hs
import os

def proprocessBikeStationData():
    data = pd.read_csv("static/bike_station_coords.csv")
    data = data.sort_values(by=['Number'])
    distance_matrix = {}
    stations_list = []
    stations_coords = {}
    for _,row in data.iterrows():
        station_id = row['Number']
        latitude = row['Latitude']
        longitude = row['Longitude']
        stations_coords[station_id] = (latitude,longitude)
        stations_list.append(station_id)

    #Generate nearest stations for each station
    for station_id in stations_list:
        distance_vector = []
        source = stations_coords[station_id]
        for i in range(len(stations_list)):
            destination = stations_coords[stations_list[i]]
            distance = calculate_distance(source,destination)
            distance_vector.append((stations_list[i],distance))
        distance_vector = sorted(distance_vector, key=lambda item: item[1])
        nearest_stations = [station_id for station_id,_ in distance_vector]
        distance_matrix[station_id] = nearest_stations
    return distance_matrix

def calculate_distance(source_coords,destination_coords):
    if source_coords == destination_coords:
        return 0
    else:
        distance = abs(hs.haversine(source_coords,destination_coords))
        return round(distance,2)

def generate_swap_suggestions(bikeStationData,distance_matrix):
    swap_suggestions = []
    #List of stations with their occupancy
    station_occupancy = {}
    for station in bikeStationData:
        station_id = int(station.station_id)
        current_occupancy = station.occupancy_list[0]
        station_occupancy[station_id] = current_occupancy
    
    #Select stations for which we need to generate suggestions
    station_occupancy_list = sorted(station_occupancy.items(), key=lambda item: item[1]) 
    
    top_5_occupied_stations = []
    top_5_free_stations = []
    for station in station_occupancy_list:
        if station[1] >= 0.50:
            top_5_occupied_stations.append(station[0])
        if station[1] <= 0.25:
            top_5_free_stations.append(station[0])
    
    top_5_occupied_stations = top_5_occupied_stations[-5:]
    top_5_free_stations = top_5_free_stations[:5]
    
    
    #Filter table and find the nearest station for each station
    for station_id in top_5_occupied_stations:
        nearest_stations = distance_matrix[station_id]
        for nearest_station in nearest_stations:
            swap_occupancy = station_occupancy[nearest_station]
            if swap_occupancy <= 0.25:
                swap_suggestions.append((station_id,nearest_station))
                break
    
    print(f"Swap Suggestions: {swap_suggestions}")
    return swap_suggestions