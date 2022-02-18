from django.shortcuts import render
from DataTransformer.DataModel.bikeModel import BikeModel
import pandas as pd
import logging

logger = logging.getLogger("mylogger")
logger.info("Whatever to log")

# Create your views here.
def transformBikeData(inputData, isPrimarySource):
    result = {}
    stationData = []

    if isPrimarySource:
        logger.info(inputData)

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
            bikeData = BikeModel(result)
            stationData.append(bikeData)
    else:
        for apiResponse in inputData:
            result['station_id'] = str(apiResponse['number'])
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
            bikeData = BikeModel(result)
            stationData.append(bikeData)
    return stationData


def transformLUASData(apiResponse):
    return "Success"


def transformBUSData(apiResponse):
    return "Success"


def transformEventsData(apiResponse):
    return "Success"


DataTransformer = {
    "DUBLIN_BIKES": transformBikeData,
    "DUBLIN_BUS": transformBUSData,
    "DUBLIN_LUAS": transformLUASData,
    "DUBLIN_EVENTS": transformEventsData,
}

def transformData(source="DUBLIN_BIKES", apiResponse={}, isPrimarySource=True):
    return DataTransformer.get(source)(apiResponse, isPrimarySource)




