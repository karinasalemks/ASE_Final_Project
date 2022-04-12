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
        # changed station_id,_ with station_id since required Id and distance
        nearest_stations = [station_id for station_id in distance_vector]
        distance_matrix[station_id] = nearest_stations
    return distance_matrix

def calculate_distance(source_coords,destination_coords):
    if source_coords == destination_coords:
        return 0
    else:
        distance = abs(hs.haversine(source_coords,destination_coords))
        return round(distance,2)

def generate_swap_suggestions(bikeStationData,distance_matrix):
    
    #List of stations with their occupancy
    station_occupancy = {}
    station_dict = {}
    for station in bikeStationData:
        station_id = int(station.station_id)
        current_occupancy = station.occupancy_list[0]
        station_occupancy[station_id] = current_occupancy
        station_dict[station_id] = station
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
    
    result = []
    temp={}
    temp['occupied_stations'] = generate_suggestions(distance_matrix, station_occupancy, station_dict, top_5_occupied_stations,True)
    temp['free_stations']= generate_suggestions(distance_matrix, station_occupancy, station_dict, top_5_free_stations,False)
    result.append(temp)
    return result

def generate_suggestions(distance_matrix, station_occupancy, station_dict, target_stations,select_occupied_stations):
    swap_suggestions = []
    #Filter table and find the nearest station for each station
    for station_id in target_stations:
        #TODO: sync bike_station_coords.csv and API response
        if station_id not in distance_matrix :
            continue

        nearest_stations= distance_matrix[station_id]
    
        for nearest_station, distance in nearest_stations:
            if nearest_station not in station_occupancy:
                continue
            swap_occupancy = station_occupancy[nearest_station]
            if select_occupied_stations:
                if swap_occupancy <= 0.25:
                    swap_suggestions.append((station_id,nearest_station,distance))
                    break
            else:
                if swap_occupancy >= 0.70:
                    swap_suggestions.append((station_id,nearest_station,distance))
                    break
    
    result = []
    #Generate the results for target stations stations
    for suggestion in swap_suggestions:
        target_station = suggestion[0]
        suggested_station = suggestion[1]
        distance= suggestion[2]
        temp = {}
        temp['occupied_station'] = parse_data(station_dict[target_station],distance)
        temp['suggested_station'] = parse_data(station_dict[suggested_station],distance)
        result.append(temp)
    return result

def parse_data(station,distance):
    result = {}
    result['station_name'] = station.station_name
    result['occupancy'] = station.occupancy_list[0]
    result['available_bikes'] = station.available_bikes[0]
    result['distance']=distance
    return result