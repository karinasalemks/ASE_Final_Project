from django.shortcuts import render
from DataTransformer.DataModel.bikeModel import BikeModel
from predictionApp.views import predictionDublinBikes
import pandas as pd

# Create your views here.
def transformBikeData(inputData,isPrimarySource):
    result = {}
    stationData = []

    # Fetching recent observations from csv for predictions.
    recent_df = pd.read_csv('static\StationID_Recent_Observations.csv')
    recent_df.set_index('stationID', inplace=True)
    
    if isPrimarySource:
        for apiResponse in inputData:
            result['station_id'] = str(apiResponse['station_id'])
            #Call Prediction Engine here
            result['available_bikes'] = [apiResponse['available_bikes'] for i in range(25)]
            result['bike_stands'] = apiResponse['bike_stands']
            result['available_bike_stands']=apiResponse['available_bike_stands']
            #TODO: harvest_time is in timestamp.So do conversion to epochTime as required.
            result['harvest_time'] = apiResponse['harvest_time']
            result['latitude'] = apiResponse['latitude']
            result['longitude'] = apiResponse['longitude']
            result['station_name'] = apiResponse['name']
            result['station_status'] = apiResponse['status']
            bikeData = BikeModel(result)
            bikeData.calculateOccupancyList()
            stationData.append(bikeData)
    else:
        for apiResponse in inputData:
            result['station_id'] = str(apiResponse['number'])
            #Call Prediction Engine here
            result['available_bikes'] = [apiResponse['available_bikes'] for i in range(25)]
            result['bike_stands'] = apiResponse['bike_stands']
            result['available_bike_stands']=apiResponse['available_bike_stands']
            result['harvest_time'] = apiResponse['last_update']
            result['latitude'] = apiResponse['position']['lat']
            result['longitude'] = apiResponse['position']['lng']
            result['station_name'] = apiResponse['name']
            result['station_status'] = apiResponse['status']
            bikeData = BikeModel(result)
            bikeData.calculateOccupancyList()
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

def transformData(source="DUBLIN_BIKES",apiResponse={},isPrimarySource=True):
    return DataTransformer.get(source)(apiResponse,isPrimarySource)




