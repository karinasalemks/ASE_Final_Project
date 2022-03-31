from Server_DataTransformer.Server_DataModel.serverBikeModel import BikeModel
import pandas as pd
import json
import requests
from Server_DataTransformer.Server_DataModel.busModel import TRIP, STOPSEQUENCE
import xml.etree.ElementTree as ET
import numpy as np
from Server_DataTransformer.Server_DataModel.busModel import *


# Create your views here.
def transformBikeData(inputData, isPrimarySource):
    result = {}
    stationData = []

    if isPrimarySource:
        for apiResponse in inputData:
            result['station_id'] = str(apiResponse['station_id'])
            result['bike_stands'] = apiResponse['bike_stands']
            result['available_bikes'] = apiResponse['available_bikes']
            result['available_bike_stands'] = apiResponse['available_bike_stands']
            result['harvest_time'] = apiResponse['harvest_time']
            result['latitude'] = apiResponse['latitude']
            result['longitude'] = apiResponse['longitude']
            result['station_name'] = apiResponse['name']
            result['station_status'] = apiResponse['status']
            # occupancy list has to be added
            # prediction has to done in the app
            bikeData = BikeModel(result)
            stationData.append(bikeData.toJSON())
    else:
        for apiResponse in inputData:
            result["station_id"] = str(apiResponse["number"])
            result['available_bikes'] = apiResponse['available_bikes']
            result['bike_stands'] = apiResponse['bike_stands']
            result['available_bike_stands'] = apiResponse['available_bike_stands']
            timestamp = apiResponse['last_update']
            timestamp_ms = pd.to_datetime(timestamp, unit='ms')
            timestamp_formatted = timestamp_ms.strftime('%Y-%m-%dT%H:%M:%S')
            result['harvest_time'] = timestamp_formatted
            result['latitude'] = str(apiResponse['position']['lat'])
            result['longitude'] = str(apiResponse['position']['lng'])
            result['station_name'] = apiResponse['name']
            result['station_status'] = apiResponse['status']
            # occupancy list has to be added
            # prediction has to be added
            bikeData = BikeModel(result)
            stationData.append(bikeData.toJSON())
    return stationData


def transformBUSData(bus_data, isPrimarySource):
    """returns a list of TRIP objects"""
    # read bus data from request api
    bus_delays_list = bus_data["Entity"]
    trips_list = []
    stop_seq_list = []
    for trip in bus_delays_list:
        tripUpdate = trip['TripUpdate']
        trip_id = trip['Id']
        # splitting the trip id to get the route id and direction
        trip_update_split = trip_id.split(".")
        try:
            route_id = trip_update_split[2]

            #Filter route associated with dublin bus, else return. 
            if route_id not in routes_list:
                continue

            # splitting the route id to get the bus entity (bus number)
            route_split = route_id.split("-")
            bus_entity = route_split[1]
            trip_entity = tripUpdate['Trip']
            start_time = trip_entity['StartTime']
            """ 
            ScheduleRelationship has 3 values: 'Scheduled', 'Skipped', 'Canceled'
            """
            if (trip_entity['ScheduleRelationship'] == 'Scheduled'):
                try:
                    stopTimeSequences = tripUpdate['StopTimeUpdate']
                    # trip_update_split[4] is the direction of the trip
                    stop_seq_list = STOPSEQUENCE.getStopSequenceList(
                        stopTimeSequences, route_id, trip_update_split[4])
                except KeyError:
                    print("Error, no 'StopTimeUpdate' field", tripUpdate)
                    continue
        except IndexError:
            print("Error in TripId, no routes, trip Id: ", trip_id,trip_update_split)
            continue

        if len(stop_seq_list) >= 0:
            trip_obj = TRIP(trip_id, bus_entity, start_time, stop_seq_list)
            jsonObj = trip_obj.toJSON()
            trips_list.append(jsonObj)
    part_of_trips = generate_part_of_trips(trips_list)
    result = {}
    result["trips_list"] = trips_list
    result["part_of_trips"] = part_of_trips
    return result

def generate_part_of_trips(trips_list):
    part_of_trips = {}
    for trip in trips_list:
        stop_sequence = trip['stop_sequences']
        for stop_id in stop_sequence:
            if stop_id in part_of_trips:
                part_of_trips[stop_id] += 1
            else:
                part_of_trips[stop_id] = 1
    part_of_trips = sorted(part_of_trips.items(), key=lambda x: x[1], reverse=True)
    result = {}
    for item in part_of_trips:
        stop_id = item[0]
        value = item[1]
        if value >= 10:
         result[stop_id] = value
    return result


def transformLUASData(apiResponse):
    return "Success"


def transformEventsData(apiResponse):
    return "Success"

def transformWeatherForecastData(weatherXML, weatherWarning):
    weather_dict = {}
    if(weatherXML != ""):
        forecast_root = ET.fromstring(weatherXML.content)
        hour_dict = {}
        time_dict = {}
        for time in forecast_root.find("product").findall("time"):
            location = time.find("location")
            if time.get("from") == time.get("to"):
                temp_unit = time.find(
                    "location").find(
                    "temperature").get(
                    "unit")
                time_dict["temperature"] = location.find("temperature").get("value") + " " + temp_unit
                # The SI unit for wind speed is m/s. In order to convert to km/h the value must be multiplied by 3.6
                time_dict["windSpeed"] = format(float(location.find("windSpeed").get("mps")) * 3.6,
                                                '.2f') + " km/h"
                time_dict["cloudiness"] = location.find("cloudiness").get("percent") + "%"
            else:
                rainfall_unit = location.find("precipitation").get("unit")
                time_dict["rainfall"] = location.find("precipitation").get("value") + " " + rainfall_unit

                # TODO: check if probability is from 0-100 or 0-1
                if (location.find("precipitation").get("probability")) != None:
                    time_dict["rainfall_prob"] = location.find("precipitation").get("probability")
                else:
                    time_dict["rainfall_prob"] = 0.0
                hour_dict[time.get('to')] = time_dict
                time_dict = {}
        dates_key = np.unique([keys.split('T')[0] for keys in hour_dict.keys()])
        for i in dates_key:
            day_temp = [float(value.get("temperature").split(" ")[0]) for key, value in hour_dict.items() if
                        i in key.lower()]
            day_wind_speed = [float(value.get("windSpeed").split(" ")[0]) for key, value in hour_dict.items() if
                              i in key.lower()]
            day_cloudiness = [float(value.get("cloudiness").split("%")[0]) for key, value in hour_dict.items() if
                              i in key.lower()]
            day_rainfall = [float(value.get("rainfall").split(" ")[0]) for key, value in hour_dict.items() if
                            i in key.lower()]
            day_rain_prob = [float(value.get("rainfall_prob")) for key, value in hour_dict.items() if i in key.lower()]
            max_temp_value = max(day_temp)
            min_temp_value = min(day_temp)
            max_wind_speed = max(day_wind_speed)
            max_cloudiness = max(day_cloudiness)
            max_rain_prob = max(day_rain_prob)
            day_rainfall = sum(day_rainfall)
            weather_dict[i] = {"min_temp": min_temp_value, "max_temp": max_temp_value,
                               "wind_speed": max_wind_speed,
                               "cloudiness": max_cloudiness, "rain_prob": max_rain_prob, "rainfall": day_rainfall}
    if len(weatherWarning)>0:
        # TODO: covert the onset and expiry date from utc to gmt
        onsetDate = weatherWarning[0]["onset"].split("T")[0]
        expiryDate = weatherWarning[0]["expiry"].split("T")[0]
        warning_dates_range = pd.date_range(onsetDate, expiryDate, freq='D').strftime("%Y-%m-%d").tolist()
        weather_warning_dict = {'level': weatherWarning[0]['level'], 'type': weatherWarning[0]['type'],
                                'certainty': weatherWarning[0]['certainty'], 'status': weatherWarning[0]['status'],
                                'headline': weatherWarning[0]['headline'],
                                'description': weatherWarning[0]['description'],
                                'onset': weatherWarning[0]['onset'], 'expiry': weatherWarning[0]['expiry']}
        for date_range in warning_dates_range:
            if date_range in weather_dict:
                temp = weather_dict[date_range]
                temp['warning'] = weather_warning_dict
            else:
                temp={}
                temp['warning'] = weather_warning_dict
            weather_dict[date_range] = temp
    return weather_dict

DataTransformer = {
    "DUBLIN_BIKES": transformBikeData,
    "DUBLIN_BUS": transformBUSData,
    "DUBLIN_LUAS": transformLUASData,
    "DUBLIN_EVENTS": transformEventsData,
    "DUBLIN_WEATHER_FORECAST": transformWeatherForecastData,
}


def transformData(source="DUBLIN_BIKES", apiResponse={}, isPrimarySource=True):
    return DataTransformer.get(source)(apiResponse, isPrimarySource)

def transformWeatherData(weatherXML, weatherWarning, isPrimarySource=True):
   return transformWeatherForecastData(weatherXML,weatherWarning)
